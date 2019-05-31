package com.finotek.board.dto;

public class BoardDTO {
	String WDATE;	// �Խñ� �ۼ��� ����
	String TITLE;	// �Խñ����� ����
	String CONTENT; // �Խñ� ���� ����
	String TYPE;	// �Խñ� ī�װ� ����
	String BID;		// �Խñ� ������ȣ
	String WRITER;

	public String getWDATE() {
		return WDATE;
	}

	public BoardDTO setWDATE(String WDATE) {
		this.WDATE = WDATE;
		return this;
	}

	public String getTITLE() {
		return TITLE;
	}

	public BoardDTO setTITLE(String TITLE) {
		this.TITLE = TITLE;
		return this;
	}

	public String getCONTENT() {
		return CONTENT;
	}

	public BoardDTO setCONTENT(String CONTENT) {
		this.CONTENT = CONTENT;
		return this;
	}

	public String getTYPE() {
		return TYPE;
	}

	public BoardDTO setTYPE(String TYPE) {
		this.TYPE = TYPE;
		return this;
	}

	public String getBID() {
		return BID;
	}

	public BoardDTO setBID(String BID) {
		this.BID = BID;
		return this;
	}

	public String getWRITER() {
		return WRITER;
	}

	public BoardDTO setWRITER(String WRITER) {
		this.WRITER = WRITER;
		return this;
	}
}
