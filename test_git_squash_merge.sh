function make_commits {
	git checkout master
	echo "James" > test.txt
	git add -A
	git commit -m "First commit from master"
	git branch feature1
	echo "John" >> test.txt
	git add -u
	git commit -m "Second commit from master"

	git checkout feature1
	echo "New" > second_test.txt
	git add -A
	git commit -m "First commit from feature 1"
	echo "Another new" >> second_test.txt
	git add -u
	git commit -m "Second commit from feature 1"

	git checkout master
}

function make_repo {
	rm -fr "$1"
	mkdir "$1"
	cd "$1"

	git init
	git config user.name "Test User"
	git config user.email "Test@test.com"
	
	make_commits
}


make_repo test_git_squash
git merge --squash feature1
git commit -m "Squash merge"
git lg --reflog

cd ..
make_repo test_git_merge
git merge --no-edit feature1
git lg --reflog
