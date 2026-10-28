# 03. Account / Contact 관리

| 항목 | 값 |
|---|---|
| Epic | Epic 3 |
| 우선순위 | `priority:medium` |
| 관련 설명 포인트 | (직접 해당 없음) 작업 공간 격리가 적용되는 기본 CRUD |
| 선행 | 01 체험 작업 공간. 02 Lead 전환과 상호 참조 |
| TBD | TBD-8 Activity 대상 (Account·Contact 상세에 활동 탭을 둘지) |

## 1. 목적

Account(거래 대상 회사)와 Contact(그 회사의 담당자)는 Opportunity가 매달리는 기준 데이터다. 이 기능은 화려할 필요가 없고, **Lead 전환으로 만들어진 것과 직접 만든 것이 같은 방식으로 관리**되면 된다. 포트폴리오에서는 "기본 CRUD도 격리·검증 규칙을 일관되게 지킨다"를 보여 준다.

## 2. 유저 스토리

- US-ACC-1. 영업 담당자로서, 거래처 목록을 보고 거래처 하나를 열어 담당자와 진행 중인 영업 건을 한눈에 보고 싶다. 거래처 단위로 상황을 파악하기 위해.
- US-ACC-2. 영업 담당자로서, Lead 전환을 거치지 않고도 거래처와 담당자를 직접 등록하고 싶다. 이미 아는 거래처를 바로 넣기 위해.
- US-ACC-3. 영업 담당자로서, 담당자를 다른 거래처로 옮기거나 정보를 고치고 싶다. 담당자의 이직·부서 이동을 반영하기 위해.
- US-ACC-4. 영업 담당자로서, 영업 건이 걸려 있는 거래처를 실수로 지우지 않길 원한다. 진행 중인 데이터가 고아가 되지 않도록.

## 3. 인수조건

### 3.1 Account

- [ ] `AC-ACC-01` [공통] Account는 다음 정보를 가진다: 회사명(필수), 업종(선택, `00-overview.md` 4.1의 업종 목록 15개 중 하나), 웹사이트, 전화번호, 주소(한 줄), 메모, 생성 시각. 세부는 API 계약에서 확정한다.
- [ ] `AC-ACC-02` [FE] Account 목록은 회사명 검색이 되고, 각 행에 업종, 담당자 수, 열린 Opportunity 수를 보여 준다.
- [ ] `AC-ACC-03` [FE] Account 상세는 기본 정보, 소속 Contact 목록, 연결된 Opportunity 목록(단계·금액 포함)을 보여 준다. TBD-8 결정에 따라 활동 목록도 둔다.
- [ ] `AC-ACC-04` [공통] Account를 직접 생성·수정할 수 있다. 회사명이 비면 거부된다.
- [ ] `AC-ACC-05` [BE] 연결된 Opportunity가 하나라도 있는 Account는 삭제할 수 없고, 거부 사유에 "연결된 Opportunity가 있음"이 포함된다. Contact만 있는 Account를 삭제하면 소속 Contact도 함께 삭제된다. (삭제 정책은 FE가 삭제 전 확인 문구에 그대로 표시한다)
- [ ] `AC-ACC-06` [BE] Lead 전환으로 만들어진 Account는 "어느 Lead에서 왔는지"를 알 수 있다. 직접 만든 Account는 그 정보가 비어 있다.
- [ ] `AC-ACC-07` [공통] 같은 작업 공간 안에서 회사명이 중복되는 Account 생성은 **허용**한다 (MVP에서는 중복 감지 없음). 직접 생성과 Lead 전환으로 생성되는 경우 모두 같다 (`02-lead.md` §4). 단, FE는 등록 폼에서 같은 이름의 Account가 있으면 안내만 한다.

### 3.2 Contact

- [ ] `AC-CT-01` [공통] Contact는 다음 정보를 가진다: 이름(필수), 소속 Account(필수), 이메일, 전화번호, 직함, 메모, 생성 시각.
- [ ] `AC-CT-02` [FE] Contact 목록은 이름·소속 회사명 검색이 되고, 각 행에 소속 Account 링크가 있다.
- [ ] `AC-CT-03` [공통] Contact를 직접 생성·수정할 수 있다. 소속 Account는 같은 작업 공간의 Account만 선택 가능하다. 다른 작업 공간의 Account 식별자를 넣으면 `AC-COMMON-02`에 따라 "존재하지 않음"으로 거부된다.
- [ ] `AC-CT-04` [공통] Contact의 소속 Account를 바꿀 수 있다. 바꿔도 그 Contact를 주 담당자로 둔 Opportunity의 연결은 끊기지 않는다. (Opportunity의 Account와 Contact의 Account가 달라질 수 있음을 허용한다. MVP에서 정합성 강제는 하지 않는다)
- [ ] `AC-CT-05` [BE] Contact 삭제 시, 그 Contact를 주 담당자로 둔 Opportunity는 삭제되지 않고 주 담당자가 비워진다.
- [ ] `AC-CT-06` [BE] Lead 전환으로 만들어진 Contact는 "어느 Lead에서 왔는지"를 알 수 있다.

### 3.3 공통

- [ ] `AC-ACC-08` [BE] Account·Contact 모두 `AC-COMMON-01~05`를 만족한다. `AC-WS-26` 검증에 포함된다.
- [ ] `AC-ACC-09` [BE] 작업 공간당 Account·Contact 각 200건(`01-trial-workspace.md` `AC-WS-37`)을 넘는 생성은 거부된다.
- [ ] `AC-ACC-10` [BE] Account 업종에 목록 밖의 값을 넣으면 `AC-COMMON-05` 형식으로 거부된다. FE는 업종을 자유 입력이 아니라 목록에서 고르게 한다.
- [ ] `AC-ACC-11` [BE] 예시 데이터로 적재된 Account는 모두 업종 값이 채워져 있다. 값은 고객사의 산업을 따르며 작업 공간 업종과 같을 필요가 없다 (`01-trial-workspace.md` 3.4.1).

## 4. 제외 범위

- Account 계층(모회사·자회사), Account 간 관계
- Contact 역할(결정권자·실무자 등) 분류, 한 Contact가 여러 Account에 소속
- 중복 감지·병합 (Lead 전환으로 같은 회사의 Account가 거듭 생기는 경우 포함, `02-lead.md` §4)
- 파일 첨부, 명함 스캔
- 대량 가져오기(CSV)
- Account·Contact 삭제 복구

## 5. 의존성 / 열린 질문

- Account 상세의 Opportunity 목록은 04가 선행되어야 의미가 있다. FE 작업은 04 목록 조회와 묶어 진행할 수 있다.
- 활동 탭(TBD-8)은 05 결정과 함께 확정한다.
- `AC-CT-04`의 "정합성 강제 안 함"이 불편하면 범위 조정 제안을 검토한다 (`99-decisions-tbd.md`).
