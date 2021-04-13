VERSION="1.0.0"
echo "Uploading version $VERSION..."

case $1 in
  win)
    butler push release/fault-win.zip varunramesh/fault:win --userversion $VERSION
    ;;

  mac)
    butler push release/fault-mac.zip varunramesh/fault:mac --userversion $VERSION
    ;;

  linux)
    butler push release/fault.AppImage varunramesh/fault:linux --userversion $VERSION
    ;;

  love)
    butler push release/fault.love varunramesh/fault:love --userversion $VERSION
    ;;

  android)
    butler push release/fault.apk varunramesh/fault:android --userversion $VERSION
    ;;

  web)
    butler push release/web/ varunramesh/fault:web --userversion $VERSION
    ;;

  *)
    echo "Unknown platform."
    ;;
esac
