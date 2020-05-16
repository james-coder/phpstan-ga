#!/bin/sh -l

# Add Github host key authentication.
/usr/bin/ssh -T -oStrictHostKeyChecking=accept-new git@github.com || true

#ls -al ~/.ssh
#ssh-add -l

echo "$SSH_AUTH_SOCK"
ls -altr $SSH_AUTH_SOCK

/composer/vendor/bin/phpstan --version

echo "::group::Installed PHPStan extensions"
composer show | grep phpstan
echo "::endgroup::"

IGNORE_PLATFORM_REQS=""
if [ "$CHECK_PLATFORM_REQUIREMENTS" = "false" ]; then
    IGNORE_PLATFORM_REQS="--ignore-platform-reqs"
fi

NO_DEV="--no-dev"
if [ "$REQUIRE_DEV" = "true" ]; then
    NO_DEV=""
fi

#COMPOSER_COMMAND="composer install --no-scripts --no-progress $NO_DEV $IGNORE_PLATFORM_REQS"
COMPOSER_COMMAND="composer install --no-progress -vvv $NO_DEV $IGNORE_PLATFORM_REQS"
echo "::group::$COMPOSER_COMMAND"
$COMPOSER_COMMAND
echo "::endgroup::"
/composer/vendor/bin/phpstan $*
