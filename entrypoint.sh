#!/bin/sh -l

# Add Github host key authentication.
/usr/bin/ssh -T -oStrictHostKeyChecking=accept-new git@github.com || true

IGNORE_PLATFORM_REQS=""
if [ "$CHECK_PLATFORM_REQUIREMENTS" = "false" ]; then
    IGNORE_PLATFORM_REQS="--ignore-platform-reqs"
fi

NO_DEV="--no-dev"
if [ "$REQUIRE_DEV" = "true" ]; then
    NO_DEV=""
fi

COMPOSER_COMMAND="composer install --no-scripts --no-progress $NO_DEV $IGNORE_PLATFORM_REQS"
echo "::group::$COMPOSER_COMMAND"
$COMPOSER_COMMAND
echo "::endgroup::"

echo "::group::Installed PHPStan extensions"
composer show | grep phpstan
echo "::endgroup::"

./vendor/bin/phpstan --version
./vendor/bin/phpstan $*
