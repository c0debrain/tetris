.PHONY: build clean deploy lint start test

node_modules:
	@npm install

start: node_modules sounds
	@./node_modules/.bin/parcel -p 4000 index.html

build: node_modules
	@./node_modules/.bin/parcel build index.html --public-url ./

sounds:
	@./node_modules/.bin/audiosprite -e mp3 -f howler -o assets/sounds assets/samples/*.wav

deploy: build
	@aws s3 sync ./dist/ s3://tetris.joshbassett.info/ --acl public-read --delete --cache-control 'max-age=300'

test: lint

lint: node_modules
	@node_modules/.bin/standard "src/**/*.js"

clean:
	@rm -rf dist node_modules
