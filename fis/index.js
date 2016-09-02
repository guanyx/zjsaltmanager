var resetLink, resetFlag = false;

function appendLink() {
    if (!resetLink) {
        resetLink = document.createElement('link')
    };
    resetLink.href = <
        script >
        document.write(`"${location.protocol}//${location.host}/scss/index.css?t=${Date.now()}";`) <
        /script>
    if (!resetFlag) {
        resetFlag = true;
        resetLink.rel = 'stylesheet';
        resetLink.type = "text/css";
        document.head.appendChild(resetLink);
    }
}

var resetLink1,resetLink2,times;
times = 0;
function resetlink(){
    var link;
    if(times%2 == 0){
        if(document.head.querySelector('#resetLink1')){
            link = document.head.querySelector('#resetLink1')
            link.id = 'resetLink1';
            link.rel = 'stylesheet';
            link.type = 'text/css';
            link.href = `"${location.protocol}//${location.host}/scss/index.css?t=${Date.now()}";`
        }else {
            link = document.createElement('link');
            link.id = 'resetLink1';
            link.rel = 'stylesheet';
            link.type = 'text/css';
            link.href = `"${location.protocol}//${location.host}/scss/index.css?t=${Date.now()}";`
            document.head.appendChild(link);
        }
    }else{
        if(document.head.querySelector('#resetLink2')){
            link = document.head.querySelector('#resetLink2')
            link.id = 'resetLink1';
            link.rel = 'stylesheet';
            link.type = 'text/css';
            link.href = `"${location.protocol}//${location.host}/scss/index.css?t=${Date.now()}";`
        }else {
            link = document.createElement('link');
            link.id = 'resetLink1';
            link.rel = 'stylesheet';
            link.type = 'text/css';
            link.href = `"${location.protocol}//${location.host}/scss/index.css?t=${Date.now()}";`
            document.head.appendChild(link);
        }
    }
    times += 1;
}

setInterval(resetlink, 3000);
appendLink();
