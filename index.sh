#!/usr/bin/env sh

_() {
  echo "Enter a Year: "
  read -r YEAR
  echo "Please create repository named '${YEAR}' at https://github.com/new"
  echo
  echo "GitHub Username: "
  read -r USERNAME
  echo "GitHub Access token: "
  read -r ACCESS_TOKEN
  echo "Type your e-mail (to set commit e-mail, leave blank to skip): "
  read -r EMAIL
  echo "Type your name (to set git username, leave blank to skip): "
  read -r GIT_USERNAME

  [ -z "$USERNAME" ] && exit 1
  [ -z "$ACCESS_TOKEN" ] && exit 1
  [ -z "$YEAR" ] && exit 1
  [ ! -d $YEAR ] && mkdir $YEAR

  cd "${YEAR}" || exit
  git init
  [ -n "$EMAIL" ] && git config user.email "${EMAIL}"
  [ -n "$GIT_USERNAME" ] && git config user.name "${GIT_USERNAME}"
  git add .
  GIT_AUTHOR_DATE="${YEAR}-01-01T00:00:00.000Z" \
    GIT_COMMITTER_DATE="${YEAR}-01-01T00:00:00.000Z" \
    git commit --allow-empty -m "${YEAR}"
  git remote add origin "https://${ACCESS_TOKEN}@github.com/${USERNAME}/${YEAR}.git"
  git branch -M main
  git push -u origin main -f
  cd ..
  rm -rf "${YEAR}"

  echo
  echo "Cool, check your repository now: https://github.com/${USERNAME}/${YEAR}"
} && _

unset -f _
