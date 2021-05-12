package com.vn.app.webmain.mssqlweb.home.service;

import java.io.Serializable;

public class MarketNewsVO implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7575225648272242810L;
	
	
	private String name;
	private String channelId;
	private String articleId;
	private String title;
	private String content;
	private String textId;
	private String publishTime;
	private String source;
	private String lastUpdate;
	private String num;
	private String crtDate;
	private String crtTime;
	private String headImageUrl;
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getChannelId() {
		return channelId;
	}
	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}
	public String getArticleId() {
		return articleId;
	}
	public void setArticleId(String articleId) {
		this.articleId = articleId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getTextId() {
		return textId;
	}
	public void setTextId(String textId) {
		this.textId = textId;
	}
	public String getPublishTime() {
		return publishTime;
	}
	public void setPublishTime(String publishTime) {
		this.publishTime = publishTime;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getLastUpdate() {
		return lastUpdate;
	}
	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getCrtDate() {
		return crtDate;
	}
	public void setCrtDate(String crtDate) {
		this.crtDate = crtDate;
	}
	public String getCrtTime() {
		return crtTime;
	}
	public void setCrtTime(String crtTime) {
		this.crtTime = crtTime;
	}
	public String getHeadImage() {
		return headImageUrl;
	}
	public void setHeadImage(String headImage) {
		this.headImageUrl = headImage;
	}
	
	
	
	
	
	
	
	
	
	
}
