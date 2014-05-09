all: pull allocate commit push

pull:
	git fetch origin
	git reset --hard origin/allocator
	git clean -f -d v1/

allocate: v1/allocated/all

commit: allocate
	@if [ -s allocate.log ]; then \
	    echo commiting; \
	    git add -A v1 config.json; \
	    git commit -q -F allocate.log; \
	fi

push: commit
	git push origin

v1/allocated/all: config.json
	@echo writing allocations
	@python manage_jacuzzis.py

config.json:
	@echo calculating allocations
	@python allocate.py --db ${DB_URL} 2>&1 | tee allocate.log

.PHONY: config.json pull allocate commit push
