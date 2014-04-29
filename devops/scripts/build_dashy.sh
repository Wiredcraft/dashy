cd {{ dashy }}
npm install

cd lib/server

export GOPATH={{ dashy }}:{{ dashy }}/lib/server:$GOPATH

go get -t github.com/smartystreets/goconvey
go get
go test
go install

mkdir -p {{ dashy_build }}
mv dashy/* {{ dashy_build }}

cd {{ dashy_build }}
export DISPLAY=:1
export BROWSERS=Dartium

nodejs "node_modules/karma/bin/karma" start karma.conf \
    --reporters=junit,dots --port=8765 --runner-port=8766 \
    --browsers=$BROWSERS --single-run --no-colors

pub build
./dashy
