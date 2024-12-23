# Mutual Information Measure in Odin
This is a simple implementation and test setup of a lib function to calculate the Mutual Information Measure of two gray f64 images in the Odin programming language.

## Description
This is a simple function lib that can be used to measure the Mutual Information between two single channel images or two 2D arrays or slices. The Mutual Information Measure, is normally also used to measure the similarity between images of different modalities, or domains, for example a MRI and a CT image of the same person. The following code is based on the fantastic article listed below. The article had code in Python using NumPy and SciPy, and used the internal histogram2D of NumPy function but the one in my repository doesn't use any external library.  And this Odin implementation is fast, because I believe that I can process an image of 10_000 x 5_000 pixels in 65 ms milliseconds in my old somewhat under powered computer, if I'm not mistaken. I made this only for recreational proposes.

## To compile and run do

``` bash
$ make
$ make run
```

## Examples of execution

```
Begin Mutual Information Measure ...
  

Image 1 len_x: 4 len_y 4 :

 0.0	 1.0	 2.0	 3.0	
 4.0	 5.0	 6.0	 7.0	
 8.0	 9.0	10.0	11.0	
12.0	13.0	14.0	15.0	

Image 2 ( little different ) len_x: 4 len_y 4 :

 1.0	 0.0	 3.0	 2.0	
 4.0	 4.0	 5.0	 7.0	
 8.0	10.0	 9.0	11.0	
12.0	15.0	14.0	16.0	

Image 3 ( more different ) len_x: 4 len_y 4 :

99.0	98.0	 0.0	10.0	
34.0	 5.0	26.0	 0.0	
80.0	 0.0	66.0	11.0	
12.0	33.0	 4.0	55.0	

Mutual Information between image 1 and image 1: 2.7726 ( equal different ) .

Mutual Information between image 1 and image 2: 2.6859 ( less different ) .

Mutual Information between image 1 and image 3: 2.5666 ( more different ) .

...end Mutual Information Measure.

```

## References on Mutual Information Measure
- **Mutual information as an image matching metric** <br>
  In which we look at the mutual information measure for comparing images. <br>
  [https://matthew-brett.github.io/teaching/mutual_information.html](https://matthew-brett.github.io/teaching/mutual_information.html)

- Paper <br>
  **Mutual Information: A Similarity Measure for Intensity Based Image Registration** <br>
  "Mutual information (MI) was independently proposed in 1995 by two groups of researchers (Maes and Collignon of Catholic University of Leuven (Collignon et al. 1995) and Wells and Viola of MIT (Viola and Wells 1995)) as a similarity measure for intensity based registration  of images acquired from different types of sensors."

- **Wikipedia Mutual information** <br>
  [https://en.wikipedia.org/wiki/Mutual_information](https://en.wikipedia.org/wiki/Mutual_information)

- **Methods of image registration in image processing** <br>
  [https://www.geeksforgeeks.org/image-registration-methods-in-image-processing/](https://www.geeksforgeeks.org/image-registration-methods-in-image-processing/)


## License
MIT Open Source License.


## Have fun!
Best regards, <br>
João Carvalho

