VERSION="1.0.0"
echo "Uploading version $VERSION..."

butler push release/fault-win.zip varunramesh/fault:win --userversion $VERSION
# butler push release/fault-macos.zip varunramesh/fault:mac --userversion $VERSION
# butler push release/fault-linux.AppImage varunramesh/fault:linux --userversion $VERSION
# butler push ./feedvid-android.apk varunramesh/feedvid:android --userversion $VERSION
