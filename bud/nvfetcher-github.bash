cd $FLAKEROOT/pkgs
nvfetcher -c ./sources.toml -l changelog --no-output
if [ ! -z "$(cat changelog)" ]; then
  echo "COMMIT_MSG<<EOF" >>$GITHUB_ENV
  echo "$(cat changelog)" >>$GITHUB_ENV
  echo "EOF" >>$GITHUB_ENV
  rm -rf changelog
else
  rm -rf changelog
fi
# Github Action Template
# schedule:
# - cron: '0 7 * * *'
# - name: Run nvfetcher
#   run: nix -Lv develop --command bud nvfetcher-github
# - name: Commit changes
#   if: ${{ env.COMMIT_MSG != null }}
#   uses: stefanzweifel/git-auto-commit-action@v4
#   with:
#     commit_message: ${{ env.COMMIT_MSG }}
