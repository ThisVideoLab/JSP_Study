
create table freeboard(
id number constraint PK_freeboard_id Primary Key, -- 자동 증가 컬럼
name varchar2(100) not null,
password varchar2(100) null,
email varchar2(100) null,
subject varchar2(100) not null, -- 글 제목
content varchar2(1000) not null, -- 글 내용
inputdate varchar2(100) not null, -- 글쓴 날짜
readcount number default 0,
-- 요 아래 3 컬럼은 질문 답변할 때 쓰는 컬럼
masterid number default 0, -- 질문 답변형 게시판에서
replynum number default 0,
step number default 0
);


select * from freeboard;