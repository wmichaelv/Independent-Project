function clickA(enumerate) {
  setTimeout(function(){
    if (enumerate <= 15) {
      document.body.getElementsByClassName("farm_icon_a")[enumerate].click()
      clickA(enumerate + 1);
    } else {
        console.log('out');
    }
  }, 333);
}

function runMe() {
    clickA(1);
}

runMe();
