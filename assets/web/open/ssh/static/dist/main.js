var term,
    protocol,
    socketURL,
    socket,
    pid,
    charWidth,
    charHeight;
var terminalContainer = document.getElementById('terminal-container');
//var host = document.getElementById('host').value;
var host = window.location.hostname + ':' + window.location.port + '/';
function setTerminalSize () {
  var cols = 128,
      rows = 24,
      width = '1000px',
      height ='500px';
  terminalContainer.style.width = width;
  terminalContainer.style.height = height;
  term.resize(cols, rows);
}
createTerminal(host);
function createTerminal(host) {
  // Clean terminal
  while (terminalContainer.children.length) {
    terminalContainer.removeChild(terminalContainer.children[0]);
  }
  term = new Terminal({
//    cols: 118,
    rows: 50,
    cursorBlink: false,
    scrollback: 1000,
    tabStopWidth: 8
  });
  term.open(terminalContainer);
  //term.fit();
  // socketURL = 'ws://100.73.35.8:2375/v1.24/containers/' + containerId + '/attach/ws?logs=0&stream=1&stdin=1&stdout=1&stderr=1';
    runId = window.localStorage.getItem('runId');
    remoteIp = window.localStorage.getItem('remoteIp');
    remotePort = window.localStorage.getItem('remotePort');
    userName = window.localStorage.getItem('userName');
    passWord = window.localStorage.getItem('passWord');
  socketURL = "http://127.0.0.1:1081/proxy/ws/connect/ssh?runId="+runId
  +"&remoteIp="+remoteIp+"&remotePort="+remotePort+"&userName="+userName+"&passWord="+passWord;
  console.log(socketURL)
  socket = new WebSocket(socketURL);
  socket.onopen = runRealTerminal;
      socket.onclose = runFakeTerminal;
      socket.onerror = runFakeTerminal;
      socket.onmessage = function (e) {
              console.log(e);
              console.warn(e.data);
  }
}
function runRealTerminal() {
  term.attach(socket);
  term._initialized = true;
}
function runFakeTerminal() {
  if (term._initialized) {
    return;
  }
  term._initialized = true;
  var shellprompt = '$ ';
  term.prompt = function () {
    term.write('\r\n' + shellprompt);
  };
  term.writeln('Welcome to xterm.js');
  term.writeln('This is a local terminal emulation, without a real terminal in the back-end.');
  term.writeln('Type some keys and commands to play around.');
  term.writeln('Warning : please check this container status !!!');
  term.prompt();
  term.on('key', function (key, ev) {
    var printable = (
      !ev.altKey && !ev.altGraphKey && !ev.ctrlKey && !ev.metaKey
    );
    if (ev.keyCode == 13) {
      term.prompt();
    } else if (ev.keyCode == 8) {
     // Do not delete the prompt
      if (term.x > 2) {
        term.write('\b \b');
      }
    } else if (printable) {
      term.write(key);
    }
  });
  term.on('paste', function (data, ev) {
    term.write(data);
  });
}
