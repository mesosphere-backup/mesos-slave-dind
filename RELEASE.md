## Release Process

1. Modify master branch

1. Make docker image

  ```
  $ make image
  docker build -t mesosphere/mesos-slave-dind:latest .
  ...
  Successfully built 1e0c8618d736
  ```

1. Tag docker image

  ```
  $ make tag
  docker tag mesosphere/mesos-slave-dind:latest mesosphere/mesos-slave-dind:0.2.3_mesos-0.24.0_docker-1.7.1_ubuntu-14.04.3
  ```

1. Validate release image (e.g. with mesos-compose-dind)

1. Create release branch

  ```
  $ git checkout -b release-${VERSION}
  ```

  (VERSION is the docker tag produced by the previous step)

1. Push release branch

  ```
  $ git push --set-upstream origin release-${VERSION}
  ```

1. Create & merge release branch to master branch

1. Switch to updated master branch

  ```
  $ git checkout master
  $ git pull
  ```

1. Tag git release

  ```
  $ make release
  git tag -a "${VERSION}" -m "mesos-slave-dind version ${VERSION}"
  ```

1. Push git tag

  ```
  $ git push --follow-tags
  Counting objects: 1, done.
  Writing objects: 100% (1/1), 203 bytes | 0 bytes/s, done.
  Total 1 (delta 0), reused 0 (delta 0)
  To git@github.com:mesosphere/mesos-slave-dind.git
   * [new tag]         0.2.3_mesos-0.24.0_docker-1.7.1_ubuntu-14.04.3 -> 0.2.3_mesos-0.24.0_docker-1.7.1_ubuntu-14.04.3
  ```

1. Push docker image

  ```
  $ make push
  docker push mesosphere/mesos-slave-dind:0.2.3_mesos-0.24.0_docker-1.7.1_ubuntu-14.04.3
  ```


To create releases with different docker versions, you will need to create a new release, modify the Dockerfile, and make a commit to the branch before you can make the new docker image. This requires knowing the release version before producing an image, which is why it's not automated. Hopefully we won't need to create too many releases with multiple docker versions.
