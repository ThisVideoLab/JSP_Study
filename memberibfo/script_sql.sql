-- 회원 정보를 저장하는 테이블

Create table mbTbl (
idx number not null, -- 시퀀스 부착
id varchar2(100) not null,
pass varchar2(100) not null,
name varchar2(100) not null,
email varchar2(100) not null,
city varchar2(100) null,
phone varchar2(100) null
)

select * from mbtbl;

alter table mbtbl
add constraint mbtbl_id_PK Primary key (id);

Create sequence seq_mbTbl_idx
    increment by 1
    start with 1
    nocache;

--  더미 데이터 입력 --

insert into mbTbl (idx, id, pass, name, email, city, phone)
values (seq_mbTbl_idx.nextval, 'admin', '1234', '관리자', 'kosmo@kosmo.com', '서울', '010-0000-0000');