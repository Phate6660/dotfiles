//META{"name":"CreationDate","website":"https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/CreationDate","source":"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/CreationDate/CreationDate.plugin.js"}*//

class CreationDate {
	getName () {return "CreationDate";}

	getVersion () {return "1.2.9";}

	getAuthor () {return "DevilBro";}

	getDescription () {return "Displays the Creation Date of an Account in the UserPopout and UserModal.";}

	initConstructor () {
		this.changelog = {
			"fixed":[["Showing at top","Fixed issue where dates would be listed at the top in the profile the first time a profile was opened or when a custom status is set"]]
		};
		
		this.labels = {};

		this.patchModules = {
			"UserPopout":"componentDidMount",
			"UserProfile":"componentDidMount"
		};

		this.languages;

		this.css = `
			${BDFDB.dotCNS.userpopout + BDFDB.dotCN.nametag} {
				margin-bottom: 4px;
			}
			${BDFDB.dotCN.userprofile} .creationDate {
				margin-right: 20px;
			}
			${BDFDB.dotCNS.themelight + BDFDB.dotCN.userpopoutheadernormal} .creationDate {
				color: #b9bbbe; 
			}
			${BDFDB.dotCNS.themelight + BDFDB.dotCN.userpopoutheader + BDFDB.notCN.userpopoutheadernormal} .creationDate,
			${BDFDB.dotCNS.themedark + BDFDB.dotCN.userpopoutheader} .creationDate {
				color: hsla(0,0%,100%,.6);
			}
			${BDFDB.dotCNS.themelight + BDFDB.dotCN.userprofiletopsectionnormal} .creationDate {
				color: hsla(216,4%,74%,.6); 
			}
			${BDFDB.dotCN.themelight} [class*='topSection']${BDFDB.notCN.userprofiletopsectionnormal} .creationDate,
			${BDFDB.dotCN.themedark} [class*='topSection'] .creationDate {
				color: hsla(0,0%,100%,.6);
			}`;


		this.defaults = {
			settings: {
				addInUserPopout:		{value:true, 		description:"Add in User Popouts:"},
				addInUserProfil:		{value:true, 		description:"Add in User Profile Modal:"},
				displayTime:			{value:true, 		description:"Display the Time in the Timestamp:"},
				displayDate:			{value:true, 		description:"Display the Date in the Timestamp:"},
				cutSeconds:				{value:false, 		description:"Cut off Seconds of the Time:"},
				forceZeros:				{value:false, 		description:"Force leading Zeros:"},
				otherOrder:				{value:false, 		description:"Show the Time before the Date:"}
			},
			choices: {
				creationDateLang:		{value:"$discord", 	description:"Creation Date Format:"}
			},
			formats: {
				ownFormat:				{value:"$hour:$minute:$second, $day.$month.$year", 	description:"Own Format:"}
			}
		};
	}

	getSettingsPanel () {
		if (!global.BDFDB || typeof BDFDB != "object" || !BDFDB.loaded || !this.started) return;
		let settings = BDFDB.getAllData(this, "settings");
		let choices = BDFDB.getAllData(this, "choices");
		let formats = BDFDB.getAllData(this, "formats");
		let settingshtml = `<div class="${this.name}-settings BDFDB-settings"><div class="${BDFDB.disCNS.titledefault + BDFDB.disCNS.title + BDFDB.disCNS.size18 + BDFDB.disCNS.height24 + BDFDB.disCNS.weightnormal + BDFDB.disCN.marginbottom8}">${this.name}</div><div class="BDFDB-settings-inner">`;
		for (let key in settings) {
			settingshtml += `<div class="${BDFDB.disCNS.flex + BDFDB.disCNS.flex2 + BDFDB.disCNS.horizontal + BDFDB.disCNS.horizontal2 + BDFDB.disCNS.directionrow + BDFDB.disCNS.justifystart + BDFDB.disCNS.aligncenter + BDFDB.disCNS.nowrap + BDFDB.disCN.marginbottom8}" style="flex: 1 1 auto;"><h3 class="${BDFDB.disCNS.titledefault + BDFDB.disCNS.title + BDFDB.disCNS.marginreset + BDFDB.disCNS.weightmedium + BDFDB.disCNS.size16 + BDFDB.disCNS.height24 + BDFDB.disCN.flexchild}" style="flex: 1 1 auto;">${this.defaults.settings[key].description}</h3><div class="${BDFDB.disCNS.flexchild + BDFDB.disCNS.switchenabled + BDFDB.disCNS.switch + BDFDB.disCNS.switchvalue + BDFDB.disCNS.switchsizedefault + BDFDB.disCNS.switchsize + BDFDB.disCN.switchthemedefault}" style="flex: 0 0 auto;"><input type="checkbox" value="settings ${key}" class="${BDFDB.disCNS.switchinnerenabled + BDFDB.disCN.switchinner} settings-switch"${settings[key] ? " checked" : ""}></div></div>`;
		}
		for (let key in choices) {
			settingshtml += `<div class="${BDFDB.disCNS.flex + BDFDB.disCNS.flex2 + BDFDB.disCNS.horizontal + BDFDB.disCNS.horizontal2 + BDFDB.disCNS.directionrow + BDFDB.disCNS.justifystart + BDFDB.disCNS.aligncenter + BDFDB.disCNS.nowrap + BDFDB.disCN.marginbottom8}" style="flex: 1 1 auto;"><h3 class="${BDFDB.disCNS.titledefault + BDFDB.disCNS.title + BDFDB.disCNS.weightmedium + BDFDB.disCNS.size16 + BDFDB.disCN.flexchild}" style="flex: 0 0 30%;">${this.defaults.choices[key].description}</h3>${BDFDB.createSelectMenu(this.createSelectChoice(choices[key]), choices[key], key)}</div>`;
		}
		for (let key in formats) {
			settingshtml += `<div class="${BDFDB.disCNS.flex + BDFDB.disCNS.flex2 + BDFDB.disCNS.horizontal + BDFDB.disCNS.horizontal2 + BDFDB.disCNS.directionrow + BDFDB.disCNS.justifystart + BDFDB.disCNS.aligncenter + BDFDB.disCNS.nowrap + BDFDB.disCN.marginbottom8}" style="flex: 1 1 auto;"><h3 class="${BDFDB.disCNS.titledefault + BDFDB.disCNS.title + BDFDB.disCNS.weightmedium + BDFDB.disCNS.size16 + BDFDB.disCN.flexchild}" style="flex: 0 0 30%;">${this.defaults.formats[key].description}</h3><div class="${BDFDB.disCNS.inputwrapper + BDFDB.disCNS.vertical + BDFDB.disCNS.flex + BDFDB.disCN.directioncolumn}" style="flex: 1 1 auto;"><input type="text" option="${key}" value="${formats[key]}" placeholder="${this.defaults.formats[key].value}" class="${BDFDB.disCNS.inputdefault + BDFDB.disCNS.input + BDFDB.disCN.size16}"></div></div>`;
		}
		let infoHidden = BDFDB.loadData("hideInfo", this, "hideInfo");
		settingshtml += `<div class="${BDFDB.disCNS.flex + BDFDB.disCNS.flex2 + BDFDB.disCNS.horizontal + BDFDB.disCNS.horizontal2 + BDFDB.disCNS.directionrow + BDFDB.disCNS.justifystart + BDFDB.disCNS.aligncenter + BDFDB.disCNS.nowrap + BDFDB.disCNS.cursorpointer} toggle-info" style="flex: 1 1 auto;"><svg class="toggle-infoarrow${infoHidden ? (" " + BDFDB.disCN.directionright) : ""}" width="12" height="12" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M7 10L12 15 17 10"></path></svg><div class="toggle-infotext" style="flex: 1 1 auto;">Information</div></div>`;
		settingshtml += `<div class="BDFDB-settings-inner-list info-container" ${infoHidden ? "style='display:none;'" : ""}>`;
		settingshtml += `<div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$hour will be replaced with the current hour</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$minute will be replaced with the current minutes</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$second will be replaced with the current seconds</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$msecond will be replaced with the current milliseconds</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$timemode will change $hour to a 12h format and will be replaced with AM/PM</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$year will be replaced with the current year</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$month will be replaced with the current month</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$day will be replaced with the current day</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$monthnameL will be replaced with the monthname in long format based on the Discord Language</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$monthnameS will be replaced with the monthname in short format based on the Discord Language</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$weekdayL will be replaced with the weekday in long format based on the Discord Language</div><div class="${BDFDB.disCNS.description + BDFDB.disCNS.formtext + BDFDB.disCNS.note + BDFDB.disCNS.modedefault + BDFDB.disCN.primary}">$weekdayS will be replaced with the weekday in short format based on the Discord Language</div>`;
		settingshtml += `</div></div>`;

		let settingspanel = BDFDB.htmlToElement(settingshtml);

		BDFDB.initElements(settingspanel, this);

		BDFDB.addEventListener(this, settingspanel, "click", ".settings-switch", () => {setImmediate(() => {this.updateSettingsPanel(settingspanel);})});
		BDFDB.addEventListener(this, settingspanel, "keyup", BDFDB.dotCN.input, () => {this.saveInputs(settingspanel);});
		BDFDB.addEventListener(this, settingspanel, "click", ".toggle-info", e => {this.toggleInfo(e.currentTarget);});
		BDFDB.addEventListener(this, settingspanel, "click", BDFDB.dotCN.selectcontrol, e => {
			BDFDB.openDropdownMenu(e, this.saveSelectChoice.bind(this), this.createSelectChoice.bind(this), this.languages, "inSettings");
		});
		return settingspanel;
	}

	//legacy
	load () {}

	start () {
		if (!global.BDFDB) global.BDFDB = {myPlugins:{}};
		if (global.BDFDB && global.BDFDB.myPlugins && typeof global.BDFDB.myPlugins == "object") global.BDFDB.myPlugins[this.getName()] = this;
		var libraryScript = document.querySelector('head script#BDFDBLibraryScript');
		if (!libraryScript || (performance.now() - libraryScript.getAttribute("date")) > 600000) {
			if (libraryScript) libraryScript.remove();
			libraryScript = document.createElement("script");
			libraryScript.setAttribute("id", "BDFDBLibraryScript");
			libraryScript.setAttribute("type", "text/javascript");
			libraryScript.setAttribute("src", "https://mwittrien.github.io/BetterDiscordAddons/Plugins/BDFDB.js");
			libraryScript.setAttribute("date", performance.now());
			libraryScript.addEventListener("load", () => {this.initialize();});
			document.head.appendChild(libraryScript);
			this.libLoadTimeout = setTimeout(() => {
				libraryScript.remove();
				require("request")("https://mwittrien.github.io/BetterDiscordAddons/Plugins/BDFDB.js", (error, response, body) => {
					if (body) {
						libraryScript = document.createElement("script");
						libraryScript.setAttribute("id", "BDFDBLibraryScript");
						libraryScript.setAttribute("type", "text/javascript");
						libraryScript.setAttribute("date", performance.now());
						libraryScript.innerText = body;
						document.head.appendChild(libraryScript);
					}
					this.initialize();
				});
			}, 15000);
		}
		else if (global.BDFDB && typeof BDFDB === "object" && BDFDB.loaded) this.initialize();
		this.startTimeout = setTimeout(() => {this.initialize();}, 30000);
	}

	initialize () {
		if (global.BDFDB && typeof BDFDB === "object" && BDFDB.loaded) {
			if (this.started) return;
			BDFDB.loadMessage(this);
			
			this.languages = Object.assign({"own":{name:"Own",id:"own",integrated:false,dic:false}},BDFDB.languages);

			BDFDB.WebModules.forceAllUpdates(this);
		}
		else {
			console.error(`%c[${this.getName()}]%c`, 'color: #3a71c1; font-weight: 700;', '', 'Fatal Error: Could not load BD functions!');
		}
	}


	stop () {
		if (global.BDFDB && typeof BDFDB === "object" && BDFDB.loaded) {
			BDFDB.removeEles(".creationDate");
			BDFDB.unloadMessage(this);
		}
	}


	// begin of own functions

	saveInputs (settingspanel) {
		let formats = {};
		for (let input of settingspanel.querySelectorAll(BDFDB.dotCN.input)) {
			formats[input.getAttribute("option")] = input.value;
		}
		BDFDB.saveAllData(formats, this, "formats");
		this.updateSettingsPanel(settingspanel);
	}

	updateSettingsPanel (settingspanel) {
		let choices = BDFDB.getAllData(this, "choices");
		for (let key in choices) {
			settingspanel.querySelector(`${BDFDB.dotCN.select}[type='${key}'] .languageTimestamp`).innerText = this.getTimestamp(this.languages[choices[key]].id);
		}
	}

	toggleInfo (ele) {
		BDFDB.toggleClass(ele.querySelector("svg"), BDFDB.disCN.directionright);
		BDFDB.toggleEles(ele.nextElementSibling);
		BDFDB.saveData("hideInfo", BDFDB.isEleHidden(ele.nextElementSibling), this, "hideInfo");
	}
	
	saveSelectChoice (selectWrap, type, choice) {
		if (type && choice) {
			selectWrap.querySelector(".languageName").innerText = this.languages[choice].name;
			selectWrap.querySelector(".languageTimestamp").innerText = this.getTimestamp(this.languages[choice].id);
			BDFDB.saveData(type, choice, this, "choices");
		}
	}
	
	createSelectChoice (choice) {
		return `<div class="${BDFDB.disCNS.title + BDFDB.disCNS.medium + BDFDB.disCNS.size16 + BDFDB.disCNS.height20 + BDFDB.disCNS.primary + BDFDB.disCNS.weightnormal + BDFDB.disCN.cursorpointer} languageName" style="flex: 1 1 42%; padding: 0;">${this.languages[choice].name}</div><div class="${BDFDB.disCNS.title + BDFDB.disCNS.medium + BDFDB.disCNS.size16 + BDFDB.disCNS.height20 + BDFDB.disCNS.primary + BDFDB.disCNS.weightnormal + BDFDB.disCN.cursorpointer} languageTimestamp" style="flex: 1 1 58%; padding: 0;">${this.getTimestamp(this.languages[choice].id)}</div>`;
	}

	processUserPopout (instance, wrapper) {
		if (instance.props && instance.props.user && BDFDB.getData("addInUserPopout", this, "settings")) {
			this.addCreationDate(instance.props.user, wrapper.querySelector(BDFDB.dotCN.userpopoutheadertext), wrapper.parentElement);
		}
	}

	processUserProfile (instance, wrapper) {
		if (instance.props && instance.props.user && BDFDB.getData("addInUserProfil", this, "settings")) {
			this.addCreationDate(instance.props.user, wrapper.querySelector(BDFDB.dotCN.userprofileheaderinfo), null);
		}
	}

	addCreationDate (info, container, popout) {
		if (!info || !container || container.querySelector(".creationDate")) return;
		let addTimestamp = (timestamp) => {
			if (document.contains(container)) {
				BDFDB.removeEles(container.querySelectorAll(".creationDate"));
				if (BDFDB.isObject(container.CreationDateObserver)) container.CreationDateObserver.disconnect();
				let choice = BDFDB.getData("creationDateLang", this, "choices");
				let nametag = container.querySelector(BDFDB.dotCN.nametag);
				container.insertBefore(BDFDB.htmlToElement(`<div class="creationDate BDFDB-textscrollwrapper ${BDFDB.disCN.textrow}" style="max-width: ${BDFDB.getRects(BDFDB.getParentEle(popout ? BDFDB.dotCN.userpopoutheader : BDFDB.dotCN.userprofileheaderinfo, container)).width - 20}px !important; order: 8 !important;"><div class="BDFDB-textscroll">${this.labels.createdat_text.replace("{{time}}", this.getTimestamp(this.languages[choice].id, timestamp))}</div></div>`), nametag ? nametag.nextSibling : null);
				BDFDB.initElements(container, this);
				if (popout && popout.style.transform.indexOf("translateY(-1") == -1) {
					let arect = BDFDB.getRects(document.querySelector(BDFDB.dotCN.appmount)), prect = BDFDB.getRects(popout);
					popout.style.setProperty("top", (prect.y + prect.height > arect.height ? (arect.height - prect.height) : prect.y) + "px");
				}
				container.CreationDateObserver = new MutationObserver((changes, _) => {changes.forEach((change, i) => {change.addedNodes.forEach((node) => {
					if (node && BDFDB.containsClass(node, BDFDB.disCN.nametag)) addTimestamp(timestamp);
				});});});
				container.CreationDateObserver.observe(container, {childList: true, subtree:true});
			}
		};
		addTimestamp(info.createdAt);
	}

	getTimestamp (languageid, time) {
		let timeobj = time ? time : new Date();
		if (typeof time == "string") timeobj = new Date(time);
		if (timeobj.toString() == "Invalid Date") timeobj = new Date(parseInt(time));
		if (timeobj.toString() == "Invalid Date") return;
		let settings = BDFDB.getAllData(this, "settings"), timestring = "";
		if (languageid != "own") {
			let timestamp = [];
			if (settings.displayDate) 	timestamp.push(timeobj.toLocaleDateString(languageid));
			if (settings.displayTime) 	timestamp.push(settings.cutSeconds ? this.cutOffSeconds(timeobj.toLocaleTimeString(languageid)) : timeobj.toLocaleTimeString(languageid));
			if (settings.otherOrder)	timestamp.reverse();
			timestring = timestamp.length > 1 ? timestamp.join(", ") : (timestamp.length > 0 ? timestamp[0] : "");
			if (timestring && settings.forceZeros) timestring = this.addLeadingZeros(timestring);
		}
		else {
			let ownformat = BDFDB.getData("ownFormat", this, "formats");
			languageid = BDFDB.getDiscordLanguage().id;
			let hour = timeobj.getHours(), minute = timeobj.getMinutes(), second = timeobj.getSeconds(), msecond = timeobj.getMilliseconds(), day = timeobj.getDate(), month = timeobj.getMonth()+1, timemode = "";
			if (ownformat.indexOf("$timemode") > -1) {
				timemode = hour >= 12 ? "PM" : "AM";
				hour = hour % 12;
				hour = hour ? hour : 12;
			}
			timestring = ownformat
				.replace("$hour", settings.forceZeros && hour < 10 ? "0" + hour : hour)
				.replace("$minute", minute < 10 ? "0" + minute : minute)
				.replace("$second", second < 10 ? "0" + second : second)
				.replace("$msecond", msecond)
				.replace("$timemode", timemode)
				.replace("$weekdayL", timeobj.toLocaleDateString(languageid,{weekday: "long"}))
				.replace("$weekdayS", timeobj.toLocaleDateString(languageid,{weekday: "short"}))
				.replace("$monthnameL", timeobj.toLocaleDateString(languageid,{month: "long"}))
				.replace("$monthnameS", timeobj.toLocaleDateString(languageid,{month: "short"}))
				.replace("$day", settings.forceZeros && day < 10 ? "0" + day : day)
				.replace("$month", settings.forceZeros && month < 10 ? "0" + month : month)
				.replace("$year", timeobj.getFullYear());
		}
		return timestring;
	}

	cutOffSeconds (timestring) {
		return timestring.replace(/(.*):(.*):(.{2})(.*)/, "$1:$2$4");
	}

	addLeadingZeros (timestring) {
		let chararray = timestring.split("");
		let numreg = /[0-9]/;
		for (let i = 0; i < chararray.length; i++) {
			if (!numreg.test(chararray[i-1]) && numreg.test(chararray[i]) && !numreg.test(chararray[i+1])) chararray[i] = "0" + chararray[i];
		}

		return chararray.join("");
	}

	setLabelsByLanguage () {
		switch (BDFDB.getDiscordLanguage().id) {
			case "hr":		//croatian
				return {
					createdat_text:				"Izrađen {{time}}"
				};
			case "da":		//danish
				return {
					createdat_text:				"Oprettet den {{time}}"
				};
			case "de":		//german
				return {
					createdat_text:				"Erstellt am {{time}}"
				};
			case "es":		//spanish
				return {
					createdat_text:				"Creado el {{time}}"
				};
			case "fr":		//french
				return {
					createdat_text:				"Créé le {{time}}"
				};
			case "it":		//italian
				return {
					createdat_text:				"Creato il {{time}}"
				};
			case "nl":		//dutch
				return {
					createdat_text:				"Gemaakt op {{time}}"
				};
			case "no":		//norwegian
				return {
					createdat_text:				"Opprettet på {{time}}"
				};
			case "pl":		//polish
				return {
					createdat_text:				"Utworzono {{time}}"
				};
			case "pt-BR":	//portuguese (brazil)
				return {
					createdat_text:				"Criado em {{time}}"
				};
			case "fi":		//finnish
				return {
					createdat_text:				"Luotu {{time}}"
				};
			case "sv":		//swedish
				return {
					createdat_text:				"Skapat den {{time}}"
				};
			case "tr":		//turkish
				return {
					createdat_text:				"Oluşturma tarihi {{time}}"
				};
			case "cs":		//czech
				return {
					createdat_text:				"Vytvořeno dne {{time}}"
				};
			case "bg":		//bulgarian
				return {
					createdat_text:				"Създадена на {{time}}"
				};
			case "ru":		//russian
				return {
					createdat_text:				"Создано {{time}}"
				};
			case "uk":		//ukrainian
				return {
					createdat_text:				"Створено {{time}}"
				};
			case "ja":		//japanese
				return {
					createdat_text:				"{{time}} 作成日"
				};
			case "zh-TW":	//chinese (traditional)
				return {
					createdat_text:				"創建於 {{time}}"
				};
			case "ko":		//korean
				return {
					createdat_text:				"{{time}} 생성 일"
				};
			default:		//default: english
				return {
					createdat_text:				"Created on {{time}}"
				};
		}
	}
}
