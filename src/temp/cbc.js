// ==UserScript==
// @name        cbc
// @namespace   Violentmonkey Scripts
// @match       https://www.cbc.ca/*
// @exclude-match https://*/*.htm
// @grant       none
// @version     1.0
// @author      -
// @description 2024. 10. 24. 오후 6:27:32
// ==/UserScript==
(function(window){
  "use strict";
  var My = {
    document:'',
    words :[],
    now:{},
    pidWordsMap:{},
    pidMap:{},
    attName:'tempValue',
    buttons:[],
    getUrl:function(){

    },

    mergeRange:function(arr){
      if(arr.length<1){
        return;
      }
      arr.sort(function(a,b){
        return a.range[0] - b.range[0];
      })
      let merged = [];
      let current = arr[0];
      for(let i = 1; i < arr.length ; i++){
        let next = arr[i];
        if(next.range[0] < current.range[1]){
          current.range[1] = Math.max(current.range[1],next.range[1]);
        }else{
          merged.push(current);
          current = next;
        }
      }
      merged.push(current);
      arr = merged;
      return arr;
    },

    addSpan:function(ori, from, to){
      let temp = ori.substring(ori,from);
      temp += My.wrapping(ori.substring(from,to));
      temp += ori.substring(to);
      return temp;
    },

    wrapping:function(word){
      let result = "<span class='highlight'>";
      result += word;
      result += "</span>";
      return result;
    },

    saveFile: async function() {
      let [_fileHandler] = await window.showOpenFilePicker({
        suggestedName: window.document.head.getElementsByTagName('title')[0].innerText,
        types: [{
          description: 'html',
          accept: {
            'text/html': ['.html'],
          },
        }],
      });
      let _file = await _fileHandler.getFile();

      let _fileContent = await _file.text();
      let _writable = await _fileHandler.createWritable();
      let title = window.document.head.getElementsByTagName('title')[0]?.innerText;
      let body = {};

      body = document.createElement('body')
      body.innerHTML = _fileContent;
      _writable.write('<!DOCTYPE html>\n<html>\n');
      // css
      _writable.write('<style>');
      _writable.write('.highlight {font-weight: bold;  font-size: large;  color: darkorange;}');
      _writable.write('div{border: 1px solid black; margin-bottom:10px}');
      _writable.write('</style>\n');

      _writable.write('<head><title>'+title+'</title></head>\n');

      _writable.write('<body>\n');

      _writable.write('<h1 id="okok">'+title+'</h1>');


      const parser = new DOMParser();
      const doc = parser.parseFromString(_fileContent, 'text/html');

      let divId = doc.getElementsByTagName('div');
      let divLen = divId.length;

      if(divLen > 0){
        for(let i=divLen-1; i>=0; i--){
          let divPLen = divId[i].getElementsByTagName('p').length;
          let pText = divId[i].getElementsByTagName('p')[divPLen-1].innerText;
          for(let j=divPLen-2; j>=0; j--){
            let divP = divId[i].getElementsByTagName('p')[j];
            let divPRange = divP.id.split("_");

            let createMap = {};
            createMap.range =[];
            createMap.range[0] = divPRange[1];
            createMap.range[1] = divPRange[2];
            createMap.pid = divPRange[0];
            createMap.selected = divP.innerText;
            createMap.fullText = pText;

            console.log("****createMap = " , createMap);
            if(!My.pidWordsMap[divId[i].id]){
              My.pidWordsMap[divId[i].id]=[]
            }
            My.pidWordsMap[divId[i].id].push(createMap)
          }
        }
      }
      console.log("****pidWordsMap = ", My.pidWordsMap);

      // _writable.write(_fileContent);
      Object.keys(My.pidWordsMap).sort(function(a,b){
        return a - b;
        }
      ).forEach((value)=>{
        let now =My.mergeRange(My.pidWordsMap[value]);
        let len = now.length;
        let fullText = now[0]?.fullText;
        while(len --> 0){
          fullText = My.addSpan(fullText, now[len].range[0], now[len].range[1]);
        }

        _writable.write('<div id="'+ now[0].pid +'">\n');

        let i = 0;
        now.forEach((word)=>{
          _writable.write('<p id="'+ now[0].pid + '_' + now[i].range[0] + '_' + now[i].range[1] + '">');
          _writable.write(word.selected);
          _writable.write('</p>\n');
          i++;
        })

        _writable.write('<p>');
        _writable.write(fullText);
        _writable.write('</p>\n');
        _writable.write('<a>　</a>\n</div>\n');
      })
      _writable.write('</body>\n</html>');

      await _writable.close();
      My.words = [];
      My.pidWordsMap = {};
      My.now = {};
    },

    keyDown:function(target){
      target.addEventListener("keydown", (event) => {
        if(event.code=='Escape'){ // add to list
          if(!My.now.pid){
            return;
          }
          My.words.push(My.now)

          if(!My.pidWordsMap[My.now.pid]){
            My.pidWordsMap[My.now.pid] = []
          }
          My.pidWordsMap[My.now.pid].push(My.now)

        }else if(event.code=='Backquote'){ // check stored list

          console.log(My.pidWordsMap)
          // console.log('now : ',My.now)
        }else if(event.code=='Backspace'){ // remove from list

          if(My.words.length > 0){
            // My.words.length -= 1;
            let pop = My.words.pop();
            My.pidWordsMap[pop.pid].pop();
          }
        }else if(event.key =='s' && event.altKey){ // save
          My.saveFile();
          console.log("file saved")
        }else if( 1 <= event.key && event.key <= 3){
          My.buttons[event.key - 1].click();
        }

      });

    },
    selectionToObj(target){
      let result = {};
      result.range =[];
      result.range[0] = target.getSelection().baseOffset
      result.range[1] = target.getSelection().focusOffset
      result.pid = target.getSelection().baseNode.parentNode.getAttribute(My.attName)
      result.selected = target.getSelection().toString();
      result.fullText = target.getSelection().baseNode.parentNode.innerText;
      return result;
    },
    mouseup:function(target){
      target.addEventListener('mouseup',function(){
        if(target.getSelection().toString()?.trim()){
          console.log(target.getSelection());
          My.now = My.selectionToObj(target);
        }else{
          My.now={};
        }
      })
    },

    removeAd:function(){
      Object.entries(document.getElementsByTagName('div')).map((t)=>{
          return t[1]
      }).forEach((t)=>{
          let str = t.getAttribute('class');
          let regex = /\bad\w*/g;
          if(typeof str =='string' && str.includes('ad')){
              if(regex.test(str)){
                  t.remove();
              }
          }
      });
    },

    findBtns:function(target){
      target.getElementsByClassName('play-button-container')[0]?.click();
      setTimeout(function(){
        Object.entries(target.getElementsByTagName('button')).filter((t)=>{
            return t[1].classList.value.includes('phx')
        }).forEach((t,i)=>{
            My.buttons.push(t[1]);
        })
      },1000)

    }
    };

  // window.onload();

  window.onload = function(e){

    if(e.target.location.host =='www.cbc.ca'){
      console.log('++ ==========================')
      My.removeAd();
      My.findBtns(e.target);
      setTimeout(function(){
          Object.entries(e.target.getElementsByTagName('iframe'))
          .map((t)=>{return t[1]})
          .forEach((t)=>{
            if(t.getAttribute('title') == ' custom content'){
              My.mouseup(t.contentWindow.document);
              My.keyDown(t.contentWindow.document);

              // p 태그 내부의 다른 태그(strong, em 등...) 제거
              // pid에 따른 텍스트 매핑
              Object.entries(t.contentWindow.document.getElementsByTagName('p'))
              .forEach((p)=>{
                // let pid = 'pid'+p[0];
                p[1].setAttribute(My.attName,p[0])
                p[1].innerHTML = p[1].innerText;

                My.pidMap[p[0]] = p[1].innerText;
              })
            }
          })

      },1000)

      console.log('-- ==========================')
    }

  }

})(window);