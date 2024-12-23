// Name        : Mutual Information Measure in Odin
//
// Description : This is a simple function lib that can be used to measure the
//               Mutual Information between two single channel images or two 2D
//               arrays or slices.
//               The Mutual Information Measure, is normally also used to
//               measure the similarity between images of different modalities,
//               or domains, for example a MRI and a CT image of the same person.
//               The following code is based on the fantastic article listed below.
//               The article was in Python using NumPy and SciPy, and used the
//               internal histogram2D of NumPy function but the one in my repository
//               doesn't use any external library.
//               And this Odin implementation is fast, because I beleave that I can
//               process an image of 10_000 x 5_000 pixels in 65 ms miliseconds,
//               in my somewhat old computer, if I'm not mistaken.
//  
//
// Date        : 2024.12.22
//
// License: MIT Open Source License.
//
// To compile and run do:
// 
// make
// make run
//
// References on Mutual Information Measure :
//
//      Mutual information as an image matching metric
//      In which we look at the mutual information measure for comparing images.
//      [https://matthew-brett.github.io/teaching/mutual_information.html](https://matthew-brett.github.io/teaching/mutual_information.html)
//
//      Paper
//      Mutual Information: A Similarity Measure for Intensity Based Image Registration
//
//      "Mutual information (MI) was independently proposed in 1995 by two groups of researchers
//      (Maes and Collignon of Catholic University of Leuven (Collignon et al. 1995) and Wells and
//      Viola of MIT (Viola and Wells 1995)) as a similarity measure for intensity based registration
//      of images acquired from different types of sensors."
//
//      Wikipedia Mutual information
//      [https://en.wikipedia.org/wiki/Mutual_information](https://en.wikipedia.org/wiki/Mutual_information)
//      
//      Methods of image registration in image processing
//      [https://www.geeksforgeeks.org/image-registration-methods-in-image-processing/](https://www.geeksforgeeks.org/image-registration-methods-in-image-processing/)
//      
//
// Have fun!


package mutual_information_measure

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"


//   This function computes the mutual information between two images img_1_slice and img_2_slice.
//   - img_1_slice and img_2_slice are assumed to be 2D arrays of size ( rows, cols )
//     that is already flatted in a 1D slice.
//   - bins specifies the number of bins to use.
//   Returns the mutual information as a f64.
mutual_information_from_2_images :: proc ( img_1 : [ ]f64,
                                           img_2 : [ ]f64,
                                           rows  : int,
                                           cols  : int,
                                           bins  : int     ) ->
                                         ( mutual_information_value : f64 ) {
    
    total_pixels : int = rows * cols

    // Find min and max values for both images
    min_img_1 : f64 = max( f64 )
    max_img_1 : f64 = min( f64 )
    min_img_2 : f64 = max( f64 )
    max_img_2 : f64 = min( f64 )
    for i in 0 ..< len( img_1 ) {

        if img_1[ i ] < min_img_1 { min_img_1 = img_1[ i ] }
        if img_1[ i ] > max_img_1 { max_img_1 = img_1[ i ] }
        if img_2[ i ] < min_img_2 { min_img_2 = img_2[ i ] }
        if img_2[ i ] > max_img_2 { max_img_2 = img_2[ i ] }
    }

    // Create linear bin edges for both images histograms.
    x_edges : [ ]f64 = make( [ ]f64, bins + 1 )
    y_edges : [ ]f64 = make( [ ]f64, bins + 1 )
    defer { 
            delete( x_edges )
            delete( y_edges )
        }

    // This is a delta, "factor de cagaço" so that I can be sure to
    // remove the "if validations" in the main loop and the most heavy
    // performance sensitive of the processing.
    // This will improe the performance.
    delta_cagaco : f64 = 0.001

    linear_space( min_img_1, max_img_1 + delta_cagaco, bins, x_edges )
    linear_space( min_img_2, max_img_2 + delta_cagaco, bins, y_edges )

    // Initialize 2D histogram with zeros
    hist_2d : [ ]int = make( [ ]int, bins * bins )
    defer { delete( hist_2d ) }


    /*
    // Fill in the 2D histogram
    // TODO: THIS IS NOT EFFICIENT!!!!
    for p  in 0 ..< total_pixels {

        x_val : f64 = img_1[ p ]
        y_val : f64 = img_2[ p ]

        x_idx : int = 0
        for i in 0 ..< bins {

            if i == bins - 1 {
                if x_val >= x_edges[ i ] && x_val <= x_edges[ i + 1 ] {
                    x_idx = i
                    break
                }
            } else {
                if x_val >= x_edges[ i ] && x_val < x_edges[ i + 1 ] {
                    x_idx = i
                    break
                }
            }
        }

        y_idx : int = 0
        for j in 0 ..< bins {

            if j == bins - 1 {
                if y_val >= y_edges[ j ] && y_val <= y_edges[ j + 1 ] {
                    y_idx = j
                    break
                }
            } else {
                if y_val >= y_edges[ j ] && y_val < y_edges[ j + 1 ] {
                    y_idx = j
                    break
                }
            }
        }

        hist_2d[x_idx][y_idx] += 1;
    }
    */

    // OPTIMIZED VERSION because the bins are all equally spaced.

    min_x_offset := x_edges[ 0 ]
    min_y_offset := y_edges[ 0 ]
    inverse_delta_x_bin : f64 = 1.0 / ( ( x_edges[ bins ] - x_edges[ 0 ] ) / f64( bins ) ) 
    inverse_delta_y_bin : f64 = 1.0 / ( ( y_edges[ bins ] - y_edges[ 0 ] ) / f64( bins ) )


    // Fill in the 2D histogram
    for p  in 0 ..< total_pixels {

        
        x_val : f64 = img_1[ p ]
        y_val : f64 = img_2[ p ]

/*
        // Debug:
        // remover
        if y_val == 0.0 {
            continue
        }
*/

/*        
        x_idx : int = int( ( x_val - x_edges[ 0 ] ) / ( ( x_edges[ bins ] - x_edges[ 0 ] ) / f64( bins ) ) )

        if x_idx < 0 {
            x_idx = 0
        } 
        if x_idx >= bins { 
            x_idx = bins - 1
        }
*/        


/*
        y_idx : int = int( ( y_val - y_edges[ 0 ] ) / ( ( y_edges[ bins ] - y_edges[ 0 ] ) / f64( bins ) ) )
        
        if y_idx < 0 {
            y_idx = 0
        }
        if y_idx >= bins {
            y_idx = bins - 1
        }
*/


        x_idx : int = int( ( x_val - min_x_offset ) * inverse_delta_x_bin )
        y_idx : int = int( ( y_val - min_y_offset ) * inverse_delta_y_bin )

        index := c2d_to_1d( x_idx, y_idx, bins )
        hist_2d[ index ] += 1
    }


    // Convert bin counts to probabilities
    total_count : int = 0
    for i in 0 ..< bins * bins {

        total_count += hist_2d[ i ]
    }

    // Probability joined pxy ( conjunta )
    pxy : [ ]f64 = make( [ ]f64, bins * bins )
    defer delete( pxy )


    for i in 0 ..< bins * bins {

        pxy[ i ] = f64( hist_2d[ i ] ) / f64 ( total_count )
    }

    // Marginals probabilities px and py
    px := make( [ ]f64, bins )
    py := make( [ ]f64, bins )
    defer {
            delete( px )
            delete( py )
        }

    // Probability px is sum over rows
    for y in 0 ..< bins {

        row_sum : f64 = 0.0
        for x in 0 ..< bins {

            index := c2d_to_1d( x, y, bins )
            row_sum += pxy[ index ]
        }
        px[ y ] = row_sum
    }

    // Probability py is sum over columns
    for x in 0 ..< bins {

        col_sum : f64 = 0.0
        for y in 0 ..< bins {

            index := c2d_to_1d( x, y, bins )
            col_sum += pxy[ index]
        }
        py[ x ] = col_sum
    }

    // Compute mutual information
    mutual_information_value = 0.0
    for y in 0 ..< bins {

        for x in 0 ..< bins {

            index := c2d_to_1d( x, y, bins )

            if pxy[ index ] > 0.0 && px[ y ] > 0.0 && py[ x ] > 0.0 {

                val : f64 = pxy[ index ] / ( px[ y ] * py[ x ] )
                mutual_information_value += pxy[ index ] * math.log_f64( val, math.E )
            }
        }
    }

    return mutual_information_value
}

// Helper function to create a linspace array:
// The linspace_slice must be externally allocated to be of size
// num_slots + 1 elements from start to end inclusive.
linear_space :: #force_inline proc ( start              : f64,
                                     end                : f64,
                                     num_slots          : int,
                                     res_linspace_slice : [ ]f64 ) {
    assert( num_slots >= 1,
            "ERROR : linspace( ), in parameter num_slots must be greater than 0" )
    
    assert( len( res_linspace_slice) == num_slots + 1,
            "ERROR : linspace( ), in parameter linspace_slice must be of size num_slots + 1" )
    
    step : f64 = ( end - start ) / f64( num_slots )
    for i in 0 ..= num_slots {
        
        res_linspace_slice[ i ] = start + f64( i ) * step
    }
}

// Helper function to convert 2D coordinates to 1D index.
c2d_to_1d :: #force_inline proc ( x, y, len_x : int ) -> int {
    
    return y * len_x + x
}
