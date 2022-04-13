# Rename a repository
The below example is for the renaming of "toolbox" --> "admin".

## Steps

1. Make sure the repo does not have the sync-to-mirrors post-receive hook, since
   that might mess up things
   - gitolite.conf: remove repo from @sigsum_repos
   - commit and push
2. Rename repo on the server and remove gl-conf, which will be regenerated
   in step 3
   - git@getuid:~/repositories$ mv toolbox.git admin.git
   - git@getuid:~/repositories$ rm admin.git/gl-conf
3. Rename repo in the config
   - edit gitolite.conf
   - commit and push
4. Add the repo back to @sigsum_repos, to undo step 1
   - edit gitolite.conf
   - commit and push
5. Fix the remote url for mirror-github to reflect new name
   - git@getuid:~/repositories$ vi admin.git/config

(To fix GH mirroring, the appropriate renaming must also happen there.)

## Credit

  - https://gitolite.com/gitolite/basic-admin.html#removingrenaming-a-repo
