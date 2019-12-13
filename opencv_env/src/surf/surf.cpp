#include <iostream> 
#include <vector> 
#include <opencv2/xfeatures2d.hpp>
#include <opencv2/highgui.hpp> 

using namespace cv; 
using namespace std; 

int main()
{
    cout << "It works! " << endl;

    Mat img1 = imread("surf_pic1.jpg", 1);
    Mat img2 = imread("surf_pic2.jpg", 1); 

    if ((img1.data == NULL) || (img2.data == NULL))
    {
        cout << "Read images failed. " << endl; 
        return -1; 
    }

    Ptr<Feature2D> surf = xfeatures2d::SURF::create(1000);
    
    vector<KeyPoint> keypoints_1, keypoints_2; 
    Mat descriptors_1, descriptors_2; 

    surf->detectAndCompute(img1, Mat(), keypoints_1, descriptors_1); 
    surf->detectAndCompute(img2, Mat(), keypoints_2, descriptors_2); 
    drawKeypoints(img1, keypoints_1, img1); 
    drawKeypoints(img2, keypoints_2, img2); 

    namedWindow("img1", 0);
    resizeWindow("img1", 500, 500); 
    imshow("img1", img1); 

    namedWindow("img2", 0);
    resizeWindow("img2", 500, 500); 
    imshow("img2", img2); 

    return 0; 
}