

function readProperty(property, defValue){
	if(localStorage[property] == null){
		return defValue;
	}
	return localStorage[property];
}


function showOptions(){
	chrome.tabs.create({url:'options.html'});
}

function openPlayer(){
    var url = "http:mypleer.com";
    
    chrome.tabs.create({selected: true, url: url});
    
    return false;
}