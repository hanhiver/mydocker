#include <iostream>
#include <vector>
#include <opencv2/xfeatures2d.hpp>
#include <opencv2/highgui.hpp>

using namespace cv;
using namespace std;

int main()
{
ÿÿÿ Mat img1 = imread("surf_pic1.jpg",1);
ÿÿÿ Mat img2 = imread("surf_pic2.jpg",1);
ÿÿÿ if ((img1.data == NULL)||(img2.data ==NULL))
ÿÿÿ {
ÿÿÿÿÿÿÿ cout << "No exist" << endl;
ÿÿÿÿÿÿÿ return -1;
ÿÿÿ }
ÿÿÿ Ptr<Feature2D> surf = xfeatures2d::SURF::create(1000);

ÿÿÿ vector<KeyPoint> keypoints_1, keypoints_2;
ÿÿÿ Mat descriptors_1, descriptors_2;

ÿÿÿ surf->detectAndCompute(img1, Mat(), keypoints_1, descriptors_1 );
ÿÿÿ surf->detectAndCompute(img2, Mat(), keypoints_2, descriptors_2 );
ÿÿÿ drawKeypoints(img1, keypoints_1, img1);
ÿÿÿ drawKeypoints(img2, keypoints_2, img2);

ÿÿÿ namedWindow("img1",0);
ÿÿÿ resizeWindow("img1",500,500);
ÿÿÿ imshow("img1", img1);

ÿÿÿ namedWindow("img2",0);
ÿÿÿ resizeWindow("img2",500,500);
ÿÿÿ imshow("img2", img2);

ÿÿÿ FlannBasedMatcher matcher;
ÿÿÿ std::vector< DMatch > matches;
ÿÿÿ matcher.match( descriptors_1, descriptors_2, matches );
ÿÿÿ double max_dist = 0; double min_dist = 100;

ÿÿÿ for( int i = 0; i < descriptors_1.rows; i++ )
ÿÿÿ { double dist = matches[i].distance;
ÿÿÿÿÿ if( dist < min_dist ) min_dist = dist;
ÿÿÿÿÿ if( dist > max_dist ) max_dist = dist;
ÿÿÿ }
ÿÿÿ printf("-- Max dist : %f \n", max_dist );
ÿÿÿ printf("-- Min dist : %f \n", min_dist );

ÿÿÿ std::vector< DMatch > good_matches;
ÿÿÿ for( int i = 0; i < descriptors_1.rows; i++ )
ÿÿÿ { if( matches[i].distance <= max(2*min_dist, 0.02) )
ÿÿÿÿÿ { good_matches.push_back( matches[i]); }
ÿÿÿ }

ÿÿÿ Mat img_matches;
ÿÿÿ drawMatches( img1, keypoints_1, img2, keypoints_2,
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );

ÿÿÿ namedWindow("Good Matches",0);
ÿÿÿ resizeWindow("Good Matches",800,800);
ÿÿÿ imshow( "Good Matches", img_matches );

ÿÿÿ for( int i = 0; i < (int)good_matches.size(); i++ )
ÿÿÿ { printf( "-- Good Match [%d] Keypoint 1: %dÿ -- Keypoint 2: %dÿ \n",
ÿÿÿÿÿÿÿÿÿÿÿÿÿ i, good_matches[i].queryIdx, good_matches[i].trainIdx ); }

ÿÿÿ waitKey(0);
ÿÿÿ return 0;
}
