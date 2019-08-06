//META{"name":"TopRoleEverywhere","website":"https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/TopRoleEverywhere","source":"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/TopRoleEverywhere/TopRoleEverywhere.plugin.js"}*//

class TopRoleEverywhere {
	getName () {return "TopRoleEverywhere";}

	getVersion () {return "2.8.3";}

	getAuthor () {return "DevilBro";}

	getDescription () {return "Adds the highest role of a user as a tag.";}

	initConstructor () {
		this.changelog = {
			"fixed":[["Overflow","Long role names now properly overflow with overflow ellipsis"]]
		};
		
		this.patchModules = {
			"ChannelMember":"componentDidMount",
			"MessageUsername":"componentDidMount",
			"StandardSidebarView":"componentWillUnmount"
		};

		this.css = `
			.TRE-tag {
				border-radius: 3px;
				box-sizing: border-box;
				display: inline-block;
				flex-shrink: 0;
				font-size: 10px;
				font-weight: 500;
				height: 15px;
				line-height: 12px;
				margin-left: 6px;
				padding: 1px 2px;
				position: relative;
				text-indent: 0px !important;
				vertical-align: top;
				white-space: nowrap;
			}
			.TRE-tag .role-inner {
				overflow: hidden;
				text-overflow: ellipsis;
				text-transform: uppercase;
			}
			${BDFDB.dotCN.messagegroup} .TRE-tag {
				bottom: 2px;
			}
			.BE-badges + .TRE-tag {
				margin-left: 0;
			}`;

		this.tagMarkup = `<div class="TRE-tag"><div class="role-inner"></div></div>`;

		this.defaults = {
			settings: {
				showInChat:			{value:true, 	description:"Show Tag in Chat Window."},
				showInMemberList:	{value:true, 	description:"Show Tag in Member List."},
				useOtherStyle:		{value:false, 	description:"Use other Tagstyle."},
				includeColorless:	{value:false, 	description:"Include colorless roles."},
				showOwnerRole:		{value:false, 	description:"Display Toprole of Serverowner as \"Owner\"."},
				disableForBots:		{value:false, 	description:"Disable Toprole for Bots."},
				addUserID:			{value:false, 	description:"Add the UserID as a Tag to the Chat Window."},
				darkIdTag:			{value:false, 	description:"Use a dark version for the UserID-Tag."}
			}
		};
	}

	getSettingsPanel () {
		if (!global.BDFDB || typeof BDFDB != "object" || !BDFDB.loaded || !this.started) return;
		let settings = BDFDB.getAllData(this, "settings"); 
		let settingshtml = `<div class="${this.name}-settings BDFDB-settings"><div class="${BDFDB.disCNS.titledefault + BDFDB.disCNS.title + BDFDB.disCNS.size18 + BDFDB.disCNS.height24 + BDFDB.disCNS.weightnormal + BDFDB.disCN.marginbottom8}">${this.name}</div><div class="BDFDB-settings-inner">`;
		for (let key in settings) {
			settingshtml += `<div class="${BDFDB.disCNS.flex + BDFDB.disCNS.flex2 + BDFDB.disCNS.horizontal + BDFDB.disCNS.horizontal2 + BDFDB.disCNS.directionrow + BDFDB.disCNS.justifystart + BDFDB.disCNS.aligncenter + BDFDB.disCNS.nowrap + BDFDB.disCN.marginbottom8}" style="flex: 1 1 auto;"><h3 class="${BDFDB.disCNS.titledefault + BDFDB.disCNS.title + BDFDB.disCNS.marginreset + BDFDB.disCNS.weightmedium + BDFDB.disCNS.size16 + BDFDB.disCNS.height24 + BDFDB.disCN.flexchild}" style="flex: 1 1 auto;">${this.defaults.settings[key].description}</h3><div class="${BDFDB.disCNS.flexchild + BDFDB.disCNS.switchenabled + BDFDB.disCNS.switch + BDFDB.disCNS.switchvalue + BDFDB.disCNS.switchsizedefault + BDFDB.disCNS.switchsize + BDFDB.disCN.switchthemedefault}" style="flex: 0 0 auto;"><input type="checkbox" value="settings ${key}" class="${BDFDB.disCNS.switchinnerenabled + BDFDB.disCN.switchinner} settings-switch"${settings[key] ? " checked" : ""}></div></div>`;
		}
		settingshtml += `</div></div>`;

		let settingspanel = BDFDB.htmlToElement(settingshtml);

		BDFDB.initElements(settingspanel, this);

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

			this.GuildPerms = BDFDB.WebModules.findByProperties("getHighestRole");
			this.GuildStore = BDFDB.WebModules.findByProperties("getGuild");
			this.UserGuildState = BDFDB.WebModules.findByProperties("getGuildId", "getLastSelectedGuildId");

			BDFDB.WebModules.forceAllUpdates(this);
		}
		else {
			console.error(`%c[${this.getName()}]%c`, 'color: #3a71c1; font-weight: 700;', '', 'Fatal Error: Could not load BD functions!');
		}
	}

	stop () {
		if (global.BDFDB && typeof BDFDB === "object" && BDFDB.loaded) {
			BDFDB.removeEles(".TRE-tag");
			BDFDB.unloadMessage(this);
		}
	}


	// begin of own functions

	processChannelMember (instance, wrapper) {
		if (instance.props && BDFDB.getData("showInMemberList", this, "settings")) {
			this.addRoleTag(instance.props.user, wrapper.querySelector(BDFDB.dotCN.memberusername), "list");
		}
	}

	processMessageUsername (instance, wrapper) {
		let message = BDFDB.getReactValue(instance, "props.message");
		if (message) {
			let username = wrapper.querySelector(BDFDB.dotCN.messageusername);
			if (username && BDFDB.getData("showInChat", this, "settings")) this.addRoleTag(message.author, username, "chat");
		}
	}

	processStandardSidebarView (instance, wrapper) {
		if (this.SettingsUpdated) {
			delete this.SettingsUpdated;
			BDFDB.removeEles(".TRE-tag");
			BDFDB.WebModules.forceAllUpdates(this);
		}
	}

	addRoleTag (info, username, type) {
		if (!info || !username) return;
		BDFDB.removeEles(username.parentElement.querySelectorAll(".TRE-tag"));
		let guild = this.GuildStore.getGuild(this.UserGuildState.getGuildId());
		let settings = BDFDB.getAllData(this, "settings");
		if (!guild || info.bot && settings.disableForBots) return;
		let role = this.GuildPerms.getHighestRole(guild, info.id);
		if ((role && (role.colorString || settings.includeColorless)) || info.id == 278543574059057154) {
			let roleColor = role && role.colorString ? BDFDB.colorCONVERT(role.colorString, "RGBCOMP") : [255,255,255];
			let roleName = role ? role.name : "";
			let oldwidth;
			if (type == "list") oldwidth = BDFDB.getRects(username).width;
			let tag = BDFDB.htmlToElement(this.tagMarkup);
			username.parentElement.insertBefore(tag, username.parentElement.querySelector("svg[name=MobileDevice]"));

			let borderColor = "rgba(" + roleColor[0] + ", " + roleColor[1] + ", " + roleColor[2] + ", 0.5)";
			let textColor = "rgb(" + roleColor[0] + ", " + roleColor[1] + ", " + roleColor[2] + ")";
			let bgColor = "rgba(" + roleColor[0] + ", " + roleColor[1] + ", " + roleColor[2] + ", 0.1)";
			let bgInner = "none";
			let roleText = roleName;
			if (settings.useOtherStyle) {
				borderColor = "transparent";
				bgColor = "rgb(" + roleColor[0] + ", " + roleColor[1] + ", " + roleColor[2] + ")";
				textColor = roleColor[0] > 180 && roleColor[1] > 180 && roleColor[2] > 180 ? "black" : "white";
			}
			if (info.id == 278543574059057154) {
				bgColor = "linear-gradient(to right, rgba(255,0,0,0.1), rgba(255,127,0,0.1) , rgba(255,255,0,0.1), rgba(127,255,0,0.1), rgba(0,255,0,0.1), rgba(0,255,127,0.1), rgba(0,255,255,0.1), rgba(0,127,255,0.1), rgba(0,0,255,0.1), rgba(127,0,255,0.1), rgba(255,0,255,0.1), rgba(255,0,127,0.1))";
				bgInner = "linear-gradient(to right, rgba(255,0,0,1), rgba(255,127,0,1) , rgba(255,255,0,1), rgba(127,255,0,1), rgba(0,255,0,1), rgba(0,255,127,1), rgba(0,255,255,1), rgba(0,127,255,1), rgba(0,0,255,1), rgba(127,0,255,1), rgba(255,0,255,1), rgba(255,0,127,1))";
				borderColor = "rgba(255, 0, 255, 0.5)";
				textColor = "transparent";
				roleText = "Plugin Creator";
				if (settings.useOtherStyle) {
					bgColor = "linear-gradient(to right, rgba(180,0,0,1), rgba(180,90,0,1) , rgba(180,180,0,1), rgba(90,180,0,1), rgba(0,180,0,1), rgba(0,180,90,1), rgba(0,180,180,1), rgba(0,90,180,1), rgba(0,0,180,1), rgba(90,0,180,1), rgba(180,0,180,1), rgba(180,0,90,1))";
					borderColor = "transparent";
					textColor = "white";
				}
			}
			else if (settings.showOwnerRole && info.id == guild.ownerId) roleText = "Owner";
			BDFDB.addClass(tag, type + "-tag");
			tag.style.setProperty("border", "1px solid " + borderColor);
			tag.style.setProperty("background", bgColor);
			tag.style.setProperty("order", 11, "important");
			let inner = tag.querySelector(".role-inner");
			inner.style.setProperty("color", textColor);
			inner.style.setProperty("background-image", bgInner);
			inner.style.setProperty("-webkit-background-clip", "text");
			inner.textContent = roleText;

			if (oldwidth && oldwidth < 100 && BDFDB.getRects(username).width < 100) {
				tag.style.setProperty("max-width", (BDFDB.getRects(BDFDB.getParentEle(BDFDB.dotCN.memberinner, username)).width - oldwidth - 15) + "px");
			}
		}
		if (type == "chat" && settings.addUserID) {
			let idtag = BDFDB.htmlToElement(this.tagMarkup);
			username.parentElement.insertBefore(idtag, username.parentElement.querySelector("svg[name=MobileDevice]"));
			let idColor = settings.darkIdTag ? [33,33,33] : [222,222,222];
			let idBorderColor = "rgba(" + idColor[0] + ", " + idColor[1] + ", " + idColor[2] + ", 0.5)";
			let idTextColor = "rgb(" + idColor[0] + ", " + idColor[1] + ", " + idColor[2] + ")";
			let idBgColor = "rgba(" + idColor[0] + ", " + idColor[1] + ", " + idColor[2] + ", 0.1)";
			let idBgInner = "none";
			if (settings.useOtherStyle) {
				idBorderColor = "transparent";
				idBgColor = "rgb(" + idColor[0] + ", " + idColor[1] + ", " + idColor[2] + ")";
				idTextColor = settings.darkIdTag ? "white" : "black";
			}
			BDFDB.addClass(idtag, "id-tag");
			idtag.style.setProperty("border", "1px solid " + idBorderColor);
			idtag.style.setProperty("background", idBgColor);
			idtag.style.setProperty("order", 12, "important");
			let idinner = idtag.querySelector(".role-inner");
			idinner.style.setProperty("color", idTextColor);
			idinner.style.setProperty("background-image", idBgInner); 
			idinner.style.setProperty("-webkit-background-clip", "text");
			idinner.textContent = info.id;
		}
	}
}
