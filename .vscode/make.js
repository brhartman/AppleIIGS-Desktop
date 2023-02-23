const { spawn } = require('child_process');
const child = spawn('make');

child.stdout.setEncoding('utf8');
child.stdout.on('data', (chunk) => {
  console.log(chunk);
});

child.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
});