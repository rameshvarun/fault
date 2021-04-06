#!/usr/bin/env python3

import sys
import os
import errno
import zipfile
import subprocess
import shutil
import tempfile
import stat

from urllib.request import urlretrieve

GAME_ID = "fault"
LOVE_VERSION = "11.3"

LOVE_WIN64 = f"https://github.com/love2d/love/releases/download/{LOVE_VERSION}/love-{LOVE_VERSION}-win64.zip"
LOVE_OSX = f"https://github.com/love2d/love/releases/download/{LOVE_VERSION}/love-{LOVE_VERSION}-macos.zip"
LOVE_LINUX = f"https://github.com/love2d/love/releases/download/{LOVE_VERSION}/love-{LOVE_VERSION}-x86_64.AppImage"

APP_IMAGE_TOOL = "https://github.com/AppImage/AppImageKit/releases/download/10/appimagetool-x86_64.AppImage"

RELEASE_DIR = "release"
TMP_DIR = tempfile.mkdtemp()
LOVE_FILE = os.path.join(RELEASE_DIR, GAME_ID + ".love")

print("Temp Directory:", TMP_DIR)

def build_linux():
	print("-- Building for Linux 64-bit --")

	# Download Love2d AppImage
	love_appimage = os.path.join(TMP_DIR, "love.AppImage")
	urlretrieve(LOVE_LINUX, love_appimage)

	# Download AppImageTool
	appimage_tool = os.path.join(TMP_DIR, 'appimagetool-x86_64.AppImage')
	urlretrieve(APP_IMAGE_TOOL, appimage_tool)

	# Make app images executable
	st = os.stat(love_appimage)
	os.chmod(love_appimage, st.st_mode | stat.S_IEXEC)
	st = os.stat(appimage_tool)
	os.chmod(appimage_tool, st.st_mode | stat.S_IEXEC)

	# Extract App Image
	subprocess.check_output([love_appimage, '--appimage-extract'], stderr=subprocess.STDOUT, cwd=TMP_DIR)

	# Fuse Game
	love_exe = os.path.join(TMP_DIR, 'squashfs-root', 'usr', 'bin', 'love')
	game_exe = tempfile.mktemp()
	with open(game_exe, 'wb') as out:
		shutil.copyfileobj(open(love_exe, "rb"), out)
		shutil.copyfileobj(open(LOVE_FILE, "rb"), out)

	os.remove(love_exe)
	os.rename(game_exe, love_exe)

	st = os.stat(love_exe)
	os.chmod(love_exe, st.st_mode | stat.S_IEXEC)

	# Rebuild AppImage
	game_appimage = GAME_ID + '.AppImage'
	subprocess.check_output([appimage_tool, 'squashfs-root', game_appimage], stderr=subprocess.STDOUT, cwd=TMP_DIR)

	shutil.move(os.path.join(TMP_DIR, game_appimage), os.path.join(RELEASE_DIR))

def build_osx():
	print("-- Building for OSX 64-bit --")
	love_zip = os.path.join(TMP_DIR, "love.zip")
	urlretrieve(LOVE_OSX, love_zip)

	try:
		subprocess.check_output(['unzip', '-q', love_zip, '-d', TMP_DIR], stderr=subprocess.STDOUT)
	except subprocess.CalledProcessError as err:
		print('-- Unzipping failed --')

	os.remove(love_zip)

	app_folder = os.path.join(TMP_DIR, GAME_ID + ".app")
	os.rename(os.path.join(TMP_DIR, "love.app"), app_folder)
	shutil.copyfile(LOVE_FILE, os.path.join(app_folder, "Contents", "Resources", GAME_ID + ".love"))
	shutil.copyfile(os.path.join("media", "Info.plist"), os.path.join(app_folder, "Contents", "Info.plist"))

	game_archive = GAME_ID + "-macos"
	shutil.move(TMP_DIR, os.path.join(RELEASE_DIR, game_archive))
	shutil.make_archive(os.path.join(RELEASE_DIR, game_archive), "zip", root_dir=os.path.join(RELEASE_DIR, game_archive))

def build_windows():
	print("-- Building for Windows 64-bit --")
	love_zip = os.path.join(TMP_DIR, "love.zip")
	urlretrieve(LOVE_WIN64, love_zip)
	with zipfile.ZipFile(love_zip, 'r') as love_zipfile: love_zipfile.extractall(TMP_DIR)
	love_folder = os.path.join(TMP_DIR, "love-" + LOVE_VERSION + "-win64")

	game_filename = os.path.join(love_folder, GAME_ID + ".exe")
	with open(game_filename, 'wb') as game_exe:
		shutil.copyfileobj(open(os.path.join(love_folder, "love.exe"), "rb"), game_exe)
		shutil.copyfileobj(open(LOVE_FILE, "rb"), game_exe)

	os.remove(os.path.join(love_folder, "love.exe"))
	os.remove(os.path.join(love_folder, "lovec.exe"))
	os.remove(os.path.join(love_folder, "readme.txt"))
	os.remove(os.path.join(love_folder, "license.txt"))
	os.remove(os.path.join(love_folder, "changes.txt"))
	os.remove(os.path.join(love_folder, "game.ico"))
	os.remove(os.path.join(love_folder, "love.ico"))

	game_archive = GAME_ID + "-win"
	shutil.move(love_folder, os.path.join(RELEASE_DIR, game_archive))
	shutil.make_archive(os.path.join(RELEASE_DIR, game_archive), "zip", root_dir=os.path.join(RELEASE_DIR, game_archive))

def make_directory(path, clear):
	# Might want to clear directory
	if clear and os.path.isdir(path):
		shutil.rmtree(path)

	# Try to create the directory
	try: os.makedirs(path)
	except OSError as err:
		# If directory already exists, continue
		if err.errno == errno.EEXIST: pass
		else: raise err

if __name__ == "__main__":
	if len(sys.argv) != 2:
		print("One argument required.")
		sys.exit(1)

	print("-- Release Script --")

	make_directory(RELEASE_DIR, False)
	make_directory(TMP_DIR, True)

	if sys.argv[1] == "win":
		build_windows()
	elif sys.argv[1] == "osx":
		build_osx()
	elif sys.argv[1] == "linux":
		build_linux()
	elif sys.argv[1] == "all":
		build_windows()
		build_osx()
		build_linux()
	else:
		print("Unkown platform")
		sys.exit(1)

	if os.path.exists(TMP_DIR):
		shutil.rmtree(TMP_DIR)
