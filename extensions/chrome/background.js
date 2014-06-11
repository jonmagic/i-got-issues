chrome.browserAction.onClicked.addListener(function(tab) {
  chrome.tabs.executeScript(tab.id, {file: "bookmarklet.js"});
});

chrome.commands.onCommand.addListener(function(command) {
  if(command == "import-issue"){
    chrome.tabs.query({"active": true}, function(tabs) {
      chrome.tabs.executeScript(tabs[0].id, {file: "bookmarklet.js"});
    });
  }
});
