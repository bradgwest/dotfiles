# Scripts

## Docs

Clone all repos which are used as sources in the `helm-charts` repo.

```bash
cd ~/src && ~/scripts/yfind.sh ~/src/helm-charts Chart.yaml ".home" \
    | awk -F '/' '{printf "git@github.com:"$(NF-1)"/"$NF".git\n"}' \
    | xargs -I {} -L1 git clone {} || true
```

## Resources

* https://sharats.me/posts/shell-script-best-practices/
