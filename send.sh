#!/bin/bash

case $1 in
  "success" )
    EMBED_COLOR=3066993
    STATUS_MESSAGE="Passed"
    ARTIFACT_URL="$CI_JOB_URL/artifacts/download"
    ;;

  "failure" )
    EMBED_COLOR=15158332
    STATUS_MESSAGE="Failed"
    ARTIFACT_URL="Not available"
    ;;

  * )
    EMBED_COLOR=0
    STATUS_MESSAGE="Status Unknown"
    ARTIFACT_URL="Not available"
    ;;
esac

shift

if [ $# -lt 1 ]; then
  echo -e "WARNING!!\nYou need to pass the WEBHOOK_URL environment variable as the second argument to this script.\nFor details & guide, visit: https://github.com/DiscordHooks/gitlab-ci-discord-webhook" && exit
fi

AUTHOR_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%aN")"
COMMITTER_NAME="$(git log -1 "$CI_COMMIT_SHA" --pretty="%cN")"
COMMIT_SUBJECT="$(git log -1 "$CI_COMMIT_SHA" --pretty="%s")"
COMMIT_MESSAGE="$(git log -1 "$CI_COMMIT_SHA" --pretty="%b")" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g'


if [ "$AUTHOR_NAME" == "$COMMITTER_NAME" ]; then
  CREDITS="$AUTHOR_NAME authored & committed"
else
  CREDITS="$AUTHOR_NAME authored & $COMMITTER_NAME committed"
fi

if [ -z $CI_MERGE_REQUEST_ID ]; then
  URL=""
else
  URL="$CI_PROJECT_URL/merge_requests/$CI_MERGE_REQUEST_ID"
fi

TIMESTAMP=$(date --utc +%FT%TZ)

if [ -z $LINK_ARTIFACT ] || [ $LINK_ARTIFACT = false ] ; then
  WEBHOOK_DATA='{
    "avatar_url": "https://gitlab.com/favicon.png",
    "embeds": [ {
      "color": '$EMBED_COLOR',
      "author": {
        "name": "Pipeline #'"$CI_PIPELINE_IID"' '"$STATUS_MESSAGE"' - '"$CI_PROJECT_PATH_SLUG"'",
        "url": "'"$CI_PIPELINE_URL"'",
        "icon_url": "https://gitlab.com/favicon.png"
      },
      "title": "'"$COMMIT_SUBJECT"'",
      "url": "'"$URL"'",
      "description": "'"${COMMIT_MESSAGE//$'\n'/ }"\\n\\n"$CREDITS"'",
      "fields": [
        {
          "name": "Commit",
          "value": "'"[\`$CI_COMMIT_SHORT_SHA\`]($CI_PROJECT_URL/commit/$CI_COMMIT_SHA)"'",
          "inline": true
        },
        {
          "name": "Branch",
          "value": "'"[\`$CI_COMMIT_REF_NAME\`]($CI_PROJECT_URL/tree/$CI_COMMIT_REF_NAME)"'",
          "inline": true
        }
        ],
        "timestamp": "'"$TIMESTAMP"'"
      } ]
    }'
else
	WEBHOOK_DATA='{
		"avatar_url": "https://gitlab.com/favicon.png",
		"embeds": [ {
			"color": '$EMBED_COLOR',
			"author": {
			"name": "Pipeline #'"$CI_PIPELINE_IID"' '"$STATUS_MESSAGE"' - '"$CI_PROJECT_PATH_SLUG"'",
			"url": "'"$CI_PIPELINE_URL"'",
			"icon_url": "https://gitlab.com/favicon.png"
			},
			"title": "'"$COMMIT_SUBJECT"'",
			"url": "'"$URL"'",
			"description": "'"${COMMIT_MESSAGE//$'\n'/ }"\\n\\n"$CREDITS"'",
			"fields": [
			{
				"name": "Commit",
				"value": "'"[\`$CI_COMMIT_SHORT_SHA\`]($CI_PROJECT_URL/commit/$CI_COMMIT_SHA)"'",
				"inline": true
			},
			{
				"name": "Branch",
				"value": "'"[\`$CI_COMMIT_REF_NAME\`]($CI_PROJECT_URL/tree/$CI_COMMIT_REF_NAME)"'",
				"inline": true
			},
			{
				"name": "Artifacts",
				"value": "'"[\`$CI_JOB_ID\`]($ARTIFACT_URL)"'",
				"inline": true
			}
			],
			"timestamp": "'"$TIMESTAMP"'"
		} ]
	}'
fi

for ARG in "$@"; do
  echo -e "[Webhook]: Sending webhook to Discord...\\n";

  (curl --fail --progress-bar -A "GitLabCI-Webhook" -H Content-Type:application/json -H X-Author:k3rn31p4nic#8383 -d "$WEBHOOK_DATA" "$ARG" \
  && echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."
done
