#!/bin/bash
# Copyright 2021 aqz/tamaina, joinmisskey
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice
# shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
misskey_user=misskey
misskey_directory=misskey

#region work with misskey user
su $misskey_user << MKEOF
set -eu;
cd ~/$misskey_directory;
git pull;
MKEOF
#endregion

systemctl stop misskey

#region work with misskey user
su $misskey_user << MKEOF
set -eu;
cd ~/$misskey_directory;
npx yarn install;
npm run clean;
NODE_ENV=production npm run build;
npm run migrate;
MKEOF
#endregion

if [ $1 == "-r" ]; then
	apt update -y;
	apt full-upgrade -y;
	reboot;
else
	systemctl start misskey;
fi
