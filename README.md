# fastapi-admin-front

## Introduction

This is front-end project for [fastapi-admin](https://github.com/long2ice/fastapi-admi) and forked from [rest-admin](https://github.com/wxs77577/rest-admin).

## Live Demo

Check a live Demo here [https://fastapi-admin.long2ice.cn](https://fastapi-admin.long2ice.cn/).

- username: `admin`
- password: `123456`

Data in database will restore every day.

## Screenshots

![login](https://github.com/fastapi-admin/vue-front/raw/master/screenshots/login.png)
![list](https://github.com/fastapi-admin/vue-front/raw/master/screenshots/list.png)
![view](https://github.com/fastapi-admin/vue-front/raw/master/screenshots/view.png)
![create](https://github.com/fastapi-admin/vue-front/raw/master/screenshots/create.png)

## Run local

1. `git clone https://github.com/fastapi-admin/vue-front.git`.
2. `cp .env.example .env` and update.
3. `yarn && yarn serve`.

```log
 DONE  Compiled successfully in 5051ms                                                                                                                                          5:05:48 PM


  App running at:
  - Local:   http://localhost:8080/
  - Network: http://192.168.10.23:8080/

  Note that the development build is not optimized.
  To create a production build, run yarn build.

```

## Rest API

See [fastapi-admin](https://github.com/long2ice/fastapi-admin) for reference.

## Deployment

1. `yarn build`
2. Copy `dist` to your server and deployment by `nginx`.

## ThanksTo

- [rest-admin](https://github.com/wxs77577/rest-admin), restful Admin Dashboard Based on Vue and Boostrap 4.

## License

This project is licensed under the [MIT](https://github.com/fastapi-admin/vue-front/blob/master/LICENSE) License.
