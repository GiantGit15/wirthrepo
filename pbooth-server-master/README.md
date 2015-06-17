Pbooth
=========

Configure the application in `config/application.yml`. Notes at bottom.

Start all processes with
```
foreman start
```
and see `Procfile` for details.

### File System

The file system should be structured as follows:
```
-- Project Root
---- Events Folder
---- Print Folder
```
They can be called anything so long as they have this structure. Add them to `config/application.yml`.

Each event must start with the following directory structure
``` 
- EventName
-- Capture
-- Client Logo
```

#### Logos and branding

Inside the `Client Logo` directory you can [optionally] add the following files:
- `logo.png`
- `print_logo.png`
- `brand_upper_left.png`

Adding `logo.png` will have the effect of overlaying this image onto gifs/photos.
Adding `print_logo.png` will overlay the image onto the print versions of the gifs/photos. Adding `brand_upper_left.png` will relace the default branding image on the iPadd app with the one added.

#### Config

An example `config/application.yml`:
``` yaml
PROJECT_ROOT: /Users/vaughan/Desktop
EVENTS_PATH: /Users/vaughan/Desktop/PhotoboothPopUp Sessions
PRINT_PATH: /Users/vaughan/Desktop/PhotoboothPopUp Print

GIF_MODE: "NO"
MAX_PHOTOS_IN_SET: 6
GIF_DELAY: 30

MOVE_FROM_CAPTURE_FOLDER: "NO"

PRINT_TO_FOLDER: "YES"

SHARE_COPY_EMAIL_SUBJECT: ""
SHARE_COPY_EMAIL_BODY: ""
SHARE_COPY_SOCIAL: ""
SHARE_COPY_TWITTER: ""

IMAGE_WIDTH: 242

BRANDED_IMAGE_WIDTH: 1200
BRANDED_IMAGE_HEIGHT: 1800

BRANDED_IMAGE_WIDTH_GIF: 1200
BRANDED_IMAGE_HEIGHT_GIF: 1800

DISPLAY_IMAGE_WIDTH: 350
DISPLAY_IMAGE_HEIGHT: 525

PRINT_IMAGE_WIDTH: 1200
PRINT_IMAGE_HEIGHT: 1800

GIF_PRINT_CROPPED_HEIGHT: 763

TWITTER_KEY: "w0GY9v8iCCB2I27n7Wrhg"
TWITTER_SECRET: "Cv2v7vjWy8pAg7aST8tpsR4WhJUf3BHPL35GR4XtNo"

FACEBOOK_KEY: "613102788765274"
FACEBOOK_SECRET: "f37a71a54e7a1e4f90feac13376505b4"

BITLY_USERNAME: "pboothup"
BITLY_TOKEN: "eb3ccacb67ab983925bbed37530aaf738fd8f4a0"

# hello@photoboothpopup.com
SMUGMUG_KEY: "4nesI0wtHo17Q9u8bmudJObQc6blEgfn"
SMUGMUG_SECRET: "7a2cf5c6827f42c796e7f138f7e05e21"
SMUGMUG_ACCESS_TOKEN: "e84185662febfd2226cf1cd9e6f98571"
SMUGMUG_ACCESS_SECRET: "e6ec11546ca328a3de3c76fb0b7587b750c4f434bc30de8e222f6e754c13d48f"
SMUGMUG_ALBUM_TITLE: "None"

```
