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
//               process an image of 10_000 x 5_000 pixels in 65 ms milliseconds,
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


package main

import "core:fmt"
import "core:math"

import mi "./mutual_information_measure"

LEN_X :: 4 
LEN_Y :: 4
TOTAL_SIZE :: LEN_X * LEN_Y 

main :: proc ( ) {

    fmt.println("\nBegin Mutual Information Measure ...\n  ")


    // Image 1
    source_img_1 := [ ? ]f64 {  0,  1,  2,  3,
                                4,  5,  6,  7,
                                8,  9, 10, 11,
                               12, 13, 14, 15  }

    // Image 2 - A little different from the first image.
    source_img_2 := [ ? ]f64 {  1,  0,  3,  2,
                                4,  4,  5,  7,
                                8, 10, 9, 11,
                               12, 15, 14, 16  }

    // Image 3 - More different from the first diffente image.
    source_img_3 := [ ? ]f64 { 99, 98,  0, 10,
                               34,  5, 26,  0,
                               80,  0, 66, 11,
                               12, 33,  4, 55  }
    
    nun_bins := 100
    // Mutual Information between image 1 and image 1.
    mi_1_1 := mi.mutual_information_from_2_images( 
                    source_img_1[ : ],
                    source_img_1[ : ],
                    LEN_X,
                    LEN_Y,
                    nun_bins )
    
    // Mutual Information between image 1 and image 2 ( little different).
    mi_1_2 := mi.mutual_information_from_2_images( 
                    source_img_1[ : ],
                    source_img_2[ : ],
                    LEN_X,
                    LEN_Y,
                    nun_bins )
                    
    // Mutual Information between image 1 and image 3 ( more different).
    mi_1_3 := mi.mutual_information_from_2_images( 
                    source_img_1[ : ],
                    source_img_3[ : ],
                    LEN_X,
                    LEN_Y,
                    nun_bins )



    fmt.printfln("\nImage 1 len_x: %d len_y %d :", LEN_X, LEN_Y )
    print_slice( source_img_1[ : ], LEN_X, LEN_Y )

    fmt.printfln("\nImage 2 ( little different ) len_x: %d len_y %d :", LEN_X, LEN_Y )
    print_slice( source_img_2[ : ], LEN_X, LEN_Y )

    fmt.printfln("\nImage 3 ( more different ) len_x: %d len_y %d :", LEN_X, LEN_Y )
    print_slice( source_img_3[ : ], LEN_X, LEN_Y )


    fmt.printfln("\nMutual Information between image 1 and image 1: %.4f ( equal different ) .", mi_1_1 )
    fmt.printfln("\nMutual Information between image 1 and image 2: %.4f ( less different ) .",  mi_1_2 )
    fmt.printfln("\nMutual Information between image 1 and image 3: %.4f ( more different ) .",  mi_1_3 )

    
    fmt.println("\n...end Mutual Information Measure.\n  ")
}

// Print array.
print_slice :: proc ( slice_vec : [ ]f64,
                      len_x     : int,
                      len_y     : int  ) {

    for y in 0 ..< len_y {

        for x in 0 ..< len_x {

            index := mi.c2d_to_1d( x, y, len_x )
            fmt.printf( "%.1f\t", slice_vec[ index ] )
        }

        fmt.println( )
    }
}

