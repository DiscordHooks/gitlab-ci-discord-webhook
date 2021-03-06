# GitLab CI 🡒 Discord Webhook
[![Backers on Open Collective](https://opencollective.com/discordhooks/backers/badge.svg)](#backers)
 [![Sponsors on Open Collective](https://opencollective.com/discordhooks/sponsors/badge.svg)](#sponsors)

If you are looking for a way to get build (success/fail) status reports from
[GitLab CI](https://gitlab.com) in [Discord](https://discordapp.com), stop
looking. You've came to the right place.

## Requirements
-  You should be using GitLab CI.
-  A Discord Server where notifications will be posted.
-  5 minutes
-  A cup of coffee ☕

## Guide
1.  Create a webhook in your Discord Server ([Guide](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks)).

1.  Copy the **Webhook URL**.

1.  Go to your repository CI/CD settings (for which you want status notifications)
    in GitLab and add an environment variable called `WEBHOOK_URL` and paste
    the **Webhook URL** you got in the previous step. You can also specify
    multiple webhook addresses at once, separating each with a whitespace
    character, such as space.

    ![Add environment variable in GitLab](https://docs.gitlab.com/ee/ci/variables/img/new_custom_variables_example.png)
    See: https://docs.gitlab.com/ee/ci/variables/#via-the-ui

1.  Add these lines, in their appropriate locations, to the `.gitlab-ci.yml`
    file of your repository.

    ```yaml
    stages:
      - notification
    success_notification:
      stage: notification
      script:
        - wget https://raw.githubusercontent.com/DiscordHooks/gitlab-ci-discord-webhook/master/send.sh
        - chmod +x send.sh
        - ./send.sh success $WEBHOOK_URL
      when: on_success
    failure_notification:
      stage: notification
      script:
        - wget https://raw.githubusercontent.com/DiscordHooks/gitlab-ci-discord-webhook/master/send.sh
        - chmod +x send.sh
        - ./send.sh failure $WEBHOOK_URL
      when: on_failure
    ```

1.  Grab your coffee ☕ and enjoy! And, if you liked this, please ⭐**Star**
    this repository to show your love.

### Artifacts

  If you'd like to also link the artifacts in the CI Message, set the variable `LINK_ARTIFACT` to `true`:

  ```yaml
  variables:
    LINK_ARTIFACT: true
  ```

  Make sure that the artifacts are available to download in the ```success_notification``` job. If they are produced by a previous one, you can follow [this StackOverflow question](https://stackoverflow.com/questions/38140996/how-can-i-pass-artifacts-to-another-stage "this StackOverflow question")

  Please also note that artifacts are only available, if ```success_notification``` has been triggered. 

### Note
-  If you face any issues in the scripts (and you're sure it's not on your side),
please consider opening an issue and I'll fix it ASAP.
-  If you want to improve the scripts, feel free to open a pull request.
-  If you are using an alpine image, you need to add `git` and `curl` packages before running this script.
   ```yaml
   # ...
     script:
       - apk add --update git curl
   # ...
   ```

### See Also
-  [Travis CI -> Discord Webhook](https://github.com/DiscordHooks/travis-ci-discord-webhook)
-  [AppVeyor -> Discord Webhook](https://github.com/DiscordHooks/appveyor-discord-webhook)

## Contributors

This project exists thanks to all the people who contribute. <img src="https://opencollective.com/DiscordHooks/contributors.svg?width=890&button=false" />


## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/DiscordHooks#backer)]

<a href="https://opencollective.com/DiscordHooks#backers" target="_blank"><img src="https://opencollective.com/DiscordHooks/backers.svg?width=890"></a>


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/DiscordHooks#sponsor)]

<a href="https://opencollective.com/DiscordHooks/sponsor/0/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/1/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/2/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/3/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/4/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/5/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/6/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/7/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/8/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/DiscordHooks/sponsor/9/website" target="_blank"><img src="https://opencollective.com/DiscordHooks/sponsor/9/avatar.svg"></a>
