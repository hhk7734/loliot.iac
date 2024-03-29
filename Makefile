.PHONY: remove_local
remove_local:
	git remote update --prune
	git switch --detach origin/main
	@git for-each-ref --format '%(refname:short)' refs/heads | xargs -r -t git branch -D

.PHONY: backup_secret
backup_secret:
	rm -rf local_secret/.pulumi/history
	rm -rf local_secret/.pulumi/backups
	tar -czvf `date "+%Y-%m-%d-%H"`_local_secret.tar.gz local_secret