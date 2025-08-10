# CMSC436 Project Proposal: Snowglobe

## Project Team 123

 * Tom Servo
 * Crow T. Robot
 * Joel Robinson

## App Description

This app will be a simulation of a souvenier snow globe, such as you
might get while on vacation. It will come pre-populated with photos of
landmarks, and the user will be able to add their own photos to the
app. Shaking the devide will cause animated "snow" to swirl around the
photo, settling down to the bottom when the device is not being
shaken. How fast the snow swirls around will depend on how vigorously
the user shakes their device.

## Minimal Goals

The app will contain two main tabs:

 * A list of images
   * Contains initial set of image assets
   * Also contains downloaded images added as local files
   * Has the ability to select one of the images
   * A button on this tab allows the user to add a local file to the list
   * Another button allows the user to take a photo with the camera and
     add it to the list
 * A snowglobe
   * Displays the selected image clipped to a circular region
   * Additional graphics add a "base" to the clipped image, making it
     look like a physical snowglobe
   * A large number of "snowflakes" are drawn over the image
   * The snowflakes fall under simulated gravity, and have horizontal
     motion damped by fluid resistance
   * Shaking the device applies randomized upward and horizontal impulses to
     the snowflakes; more vigorous shaking results in greater impulses
   * Shaking the device also plays a custom sound

There will also be a drawer with user preferences, controlling

 * the number of snowflakes
 * the size of the snowflakes
 * whether or not to play the shaking sound, and a volume slider


## Stretch Goals

We have identified the following stretch goals:

 * Add notes to the images including the date taken/downloaded and
   some descriptive text
     * The date is displayed in the list tab
     * The descriptive text is displayed on the snowglobe tab
 * A selection of background music, which can either be selected from a
   third tab or specified for a particular image
     * a new preference will control whether the music plays or not, with
       a volume slider
     * some mechanism to add/select new music

## Project Timeline

### Milestone 1

 * Images and Snowglobe tabs
 * Image assets displayed and selectable in the Images tab
 * Snowglobe tab draws the snowglobe, with the selected image
 * Snowflakes that fall under gravity, with a temporary "shake" button

### Milestone 2

 * Local image file addition to the image list
 * Accelerometer readings to detect shaking, including magnitude for impulse
 * Shaking sound
 * Removal of temporary "shake" button

### Milestone 3

 * Preferences drawer with snowflake quantity/size and shaking volume slider
 * Camera interface
 
### Final submission

Stretch goals completed, project submitted with a demonstration
video.
