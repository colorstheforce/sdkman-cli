#!/bin/bash

#
#   Copyright 2012 Marco Vermeulen
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

function __sdkman_selfupdate {
    local force_selfupdate

    force_selfupdate="$1"
	if [[ "$SDKMAN_AVAILABLE" == "false" ]]; then
		echo "This command is not available while offline."

	elif [[ "$SDKMAN_REMOTE_VERSION" == "$SDKMAN_VERSION" && "$force_selfupdate" != "force" ]]; then
		echo "No update available at this time."

	else
		curl -s "${SDKMAN_SERVICE}/selfupdate" | bash
	fi
	unset SDKMAN_FORCE_SELFUPDATE
}

function __sdkman_auto_update {
	local remote_version version delay_upgrade

    remote_version="$1"
    version="$2"
    delay_upgrade="${SDKMAN_DIR}/var/delay_upgrade"

    if [[ -n "$(find "$delay_upgrade" -mtime +1)" && "$remote_version" != "$version" ]]; then
        echo ""
        echo ""
        echo "ATTENTION: A new version of SDKMAN is available..."
        echo ""
        echo "The current version is $remote_version, but you have $version."
        echo ""

        if [[ "$sdkman_auto_selfupdate" != "true" ]]; then
            echo -n "Would you like to upgrade now? (Y/n)"
            read upgrade
        fi

        if [[ -z "$upgrade" ]]; then upgrade="Y"; fi

        if [[ "$upgrade" == "Y" || "$upgrade" == "y" ]]; then
            __sdkman_selfupdate
            unset upgrade
        else
            echo "Not upgrading today..."
        fi

        touch "${delay_upgrade}"
    fi

}
