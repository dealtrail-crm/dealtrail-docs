# 디자인 토큰 (v0.1 MVP, 라이트 모드)

dealtrail 화면 전체가 쓰는 색·타이포그래피·간격·라운드·그림자와 금액·날짜 표시 형식이다. frontend는 6장의 CSS를 web 레포 전역 스타일에 그대로 넣어 쓴다.

- 범위: 토큰과 표시 형식. 컴포넌트 스펙, 화면 흐름·레이아웃은 이 문서에 없다.
- 근거 문서: `HANDOFF.md` 0장, `prd/00-overview.md` ~ `prd/06-dashboard.md`. 각 결정 옆에 인수조건 ID를 적는다.
- 시간대: 모든 날짜·시각 표시와 날짜 경계(지연·오늘 판정)는 **한국 시간(Asia/Seoul) 고정**이다.
- 시각 확인용 미리보기: [`preview/tokens.html`](./preview/tokens.html) (브라우저로 파일을 바로 연다).

## 0. 주요 결정 요약

| 항목 | 결정 | 근거 요약 |
|---|---|---|
| 브랜드 기본색 | 인디고 `#4C43C6` (`accent`) | 흰 글자와 7.18:1. 색상각 244°로 Salesforce 파랑(`#0176D3`, 207°)과 37° 떨어져 있다 |
| 토큰 구조 | 원시 팔레트(`--dt-{hue}-{step}`) → 의미 토큰(`--dt-canvas` 등) → Tailwind 유틸리티(`bg-canvas`) | 다크 모드는 의미 토큰 값만 다시 정의하면 된다 |
| Tailwind 형식 | **Tailwind v4 `@theme`** | 새로 만드는 Next.js 프로젝트의 기본 버전이고, 토큰이 CSS 변수로 나와 다크 모드 값을 변수 재정의만으로 추가할 수 있다 |
| 열린 단계 색 | 발굴·제안·협상을 인디고 한 색의 명도 3단계로 | 순서가 있는 한 축(진행도)이라 명도 차이로 순서를 보인다 |
| 종료 단계 색 | 수주 = 초록, 실패 = 회색 | 실패는 오류가 아니라 끝난 기록이다. 빨강은 "지금 손봐야 하는 것"에만 쓴다 |
| 빨강의 의미 | 지연, 에러, 삭제·초기화 | 행동이 필요한 신호를 하나의 색으로 모은다 |
| 글꼴 | Pretendard Variable | 한글·라틴·숫자 폭이 고르고 고정폭 숫자(`tabular-nums`)를 지원한다. OFL 라이선스 |
| 기본 본문 크기 | 14px (`text-sm`), 입력란은 16px (`text-base`) | CRM은 한 화면에 정보가 많다. 입력란 16px은 iOS 자동 확대 방지 |
| 금액 형식 | **"5,000만 원"** (만·억 단위, 반올림 없음) | 5장 1절 |
| 날짜 형식 | "11월 12일", 올해가 아니면 "2027년 1월 5일". 한국 시간 고정 | 5장 2절 |
| 할 일 기한 강조 | 지연 = 빨강 연한 배지 "지연", 오늘 = 호박 채운 배지 "오늘" | 2.3 |
| 남은 시간 | 1시간 이하면 `warning` 색. 팝업·모달 없음 | 5장 2절 |
| 전화번호 | 저장 값과 상관없이 종류별 하이픈 형식으로 표시 (010-1234-5678) | 5장 4절 |
| WCAG | 정의한 텍스트 조합 모두 4.5:1 이상, UI·그래픽 조합 모두 3:1 이상 | 7장 |

## 1. 원칙

1. **의미 이름만 쓴다.** 화면 코드는 `bg-indigo-600` 같은 원시 색을 쓰지 않고 `bg-accent`, `bg-stage-won-bg`처럼 의미 토큰만 쓴다. 원시 팔레트는 유틸리티로 내보내지 않고, Tailwind 기본 팔레트도 끈다(`--color-*: initial`). 다크 모드를 추가할 때 화면 코드를 고치지 않기 위해서다.
2. **색만으로 뜻을 전하지 않는다** (WCAG 1.4.1). 단계·상태·종류는 항상 글자 라벨과 함께 보인다. 색은 빨리 훑어보게 돕는 보조 수단이다.
3. **상태는 배지, 종류는 아이콘.** 단계·Lead 상태·지연·담당자 퇴사·준비 중은 배경을 채운 배지로, 활동 종류(통화·미팅·할 일)는 아이콘 색과 라벨로 표시한다. 같은 화면에 상태 배지와 활동 종류가 함께 나와도(예: Lead 상세) 모양으로 구분된다.
4. **빨강은 행동이 필요한 것에만.** 지연, 입력 에러, 거부 사유, 초기화 버튼. 실패 단계·제외 Lead처럼 "끝났거나 빠진 것"은 회색이다.
5. **Salesforce를 따르지 않는다** (`AC-COMMON-07`). 하늘색·파랑 계열 브랜드색, 구름 모양, Salesforce Sans를 쓰지 않는다. 브랜드색은 인디고, 글꼴은 Pretendard다.

## 2. 색

### 2.1 원시 팔레트

의미 토큰이 참조하는 값이다. 화면 코드에서 직접 쓰지 않는다. 쓰는 단계만 정의했고, 나머지는 필요해질 때 추가한다.

| 계열 | 0 | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| neutral | `#FFFFFF` | `#F5F6F8` | `#ECEEF2` | `#DDE0E6` | `#C4C9D2` | `#878E9C` | `#646B79` | `#525967` | `#3D434F` | `#272C36` | `#171A21` |
| indigo (브랜드) | | `#F1F0FE` | `#E3E1FC` | `#C9C5F8` | `#A7A1F2` | `#8079E8` | `#6159DB` | `#4C43C6` | `#3D35A6` | `#322C85` | `#28246A` |
| violet | | `#F7F1FE` | | | | | `#9A4FDB` | `#8338C4` | `#6E2BA6` | | |
| teal | | `#EDFAF8` | | | | | | `#0D7C71` | `#0B655D` | | |
| green | | `#EEF9F1` | | | | | | `#18823A` | `#146A30` | | |
| amber | | `#FFF8EB` | | | | | | `#B26A05` | `#8F5207` | | |
| red | | `#FEF2F2` | | | | | | `#C02929` | `#9E2121` | | |

근거:

- **neutral**: 약간 푸른 회색. 순수 회색보다 인디고 브랜드색과 어울리고, 흰 카드와 회색 배경의 경계가 덜 탁하다. 400·500은 대비 기준(입력란 테두리 3:1, 흐린 텍스트 4.5:1)을 회색 배경 위에서도 넘도록 맞춘 값이다.
- **indigo**: 브랜드색. CRM에서 흔한 하늘색·파랑(Salesforce `#0176D3`, `#1B96FF`)을 피하면서도 업무 도구다운 차분함을 주는 색으로 골랐다. 600이 버튼·링크, 50~200이 배지 배경, 400·600·800이 단계 차트 색이다.
- **violet·teal·green·amber·red**: 상태·종류 구분용. 각 계열은 50(배경), 600(아이콘·점, 흰 바탕 3:1 이상), 700(글자, 흰 바탕과 자기 50 배경 위 4.5:1 이상) 세 단계를 기본으로 둔다.
- 그림자 색은 neutral-900(`23 26 33`)에 투명도를 준다.

### 2.2 기본 의미 토큰

토큰 이름은 Tailwind 유틸리티 이름에서 접두어를 뺀 것이다. 예: `canvas` → `bg-canvas`, `fg-muted` → `text-fg-muted`, `line` → `border-line`, `focus` → `outline-focus`.

**표면**

| 토큰 | 값 | 쓰임 |
|---|---|---|
| `canvas` | neutral-50 | 페이지 배경 |
| `surface` | neutral-0 | 카드, 패널, 표, 칸반 카드, 모달 |
| `surface-muted` | neutral-100 | 칸반 열 배경, 표 머리, 비활성 컨트롤 배경, 준비 중 업종 항목 배경 |
| `surface-hover` | neutral-50 | `surface` 위 행·항목의 hover |
| `surface-selected` | indigo-50 | 선택된 행·항목 |
| `overlay` | neutral-900, 투명도 50% | 모달 뒤 가림막 |

**글자**

| 토큰 | 값 | 쓰임 |
|---|---|---|
| `fg` | neutral-900 | 본문, 제목, 금액 |
| `fg-muted` | neutral-600 | 보조 텍스트(Account명, 라벨, 설명) |
| `fg-subtle` | neutral-500 | 메타 정보(생성 시각), placeholder |
| `fg-disabled` | neutral-400 | 비활성 컨트롤의 글자 (WCAG 대비 예외 대상, 7장) |
| `fg-on-accent` | neutral-0 | `accent`·`danger` 배경 위 글자 |
| `fg-link` | indigo-600 | 링크 |

**선**

| 토큰 | 값 | 쓰임 |
|---|---|---|
| `line` | neutral-200 | 카드·표 구분선 (장식) |
| `line-strong` | neutral-400 | 입력란 테두리, 체크박스 테두리 (3:1 필요) |
| `focus` | indigo-500 | 키보드 포커스 링. `outline-2 outline-offset-2 outline-focus` |

**동작**

| 토큰 | 값 | 쓰임 |
|---|---|---|
| `accent` | indigo-600 | 기본 버튼("체험하기", "전환", "저장") |
| `accent-hover` | indigo-700 | 기본 버튼 hover·pressed |
| `accent-bg` | indigo-50 | 보조 버튼 배경, 강조 영역 |
| `accent-fg` | indigo-700 | `accent-bg` 위 글자 |
| `danger` | red-600 | 위험 버튼(초기화 `AC-WS-23`, 삭제), 에러 아이콘, 에러 입력란 테두리 |
| `danger-hover` | red-700 | 위험 버튼 hover |

**피드백** (전환 성공 `AC-LD-17`, 단계 변경 거부 사유 `AC-OP-18`, 입력 검증 실패 `AC-COMMON-05`, 테스트 계정 안내 `AC-WS-09` 등)

| 종류 | 아이콘·테두리 (`{종류}`) | 배경 (`{종류}-bg`) | 글자 (`{종류}-fg`) |
|---|---|---|---|
| `success` | green-600 | green-50 | green-700 |
| `warning` | amber-600 | amber-50 | amber-700 |
| `danger` | red-600 | red-50 | red-700 |
| `info` | indigo-600 | indigo-50 | indigo-700 |

`danger`는 위 "동작"의 `danger`와 같은 토큰이다. 입력란 아래 에러 문구는 `danger-fg`를 쓴다.

### 2.3 도메인 상태 색

모든 상태 토큰은 같은 세 갈래를 가진다.

- `{이름}`: 진한 색. 차트 막대, 범례 점, 아이콘. 흰 바탕 3:1 이상.
- `{이름}-bg`: 배지 배경.
- `{이름}-fg`: 배지 글자. 자기 `-bg` 위 4.5:1 이상.

#### Opportunity 단계 (`prd/04-opportunity-pipeline.md` §3.2)

| 단계 | 토큰 | 진한 색 (차트) | 배지 배경 | 배지 글자 |
|---|---|---|---|---|
| 발굴 | `stage-discovery` | indigo-400 `#8079E8` | indigo-50 | indigo-700 |
| 제안 | `stage-proposal` | indigo-600 `#4C43C6` | indigo-100 | indigo-800 |
| 협상 | `stage-negotiation` | indigo-800 `#322C85` | indigo-200 | indigo-900 |
| 수주 | `stage-won` | green-600 `#18823A` | green-50 | green-700 |
| 실패 | `stage-lost` | neutral-500 `#646B79` | neutral-100 | neutral-600 |

근거:

- 열린 단계 셋은 "발굴 → 제안 → 협상" 순서를 가진 한 축이다(§3.2). 서로 다른 색상보다 **한 색의 명도 단계**가 순서를 바로 보여 준다. 대시보드 단계별 금액 막대(`AC-DB-08`)도 왼쪽에서 오른쪽으로 점점 진해진다.
- 브랜드색 계열을 쓴 이유: 파이프라인이 이 제품의 기본 화면이고(`00` §5), 열린 단계가 화면에서 가장 많이 보이는 색이 되므로 브랜드 인상과 일치시킨다.
- 수주는 초록(성과). 실패는 회색: 종료 단계는 잠긴 기록이고(`AC-OP-09`) 방문자가 손볼 것이 없으므로 경고색을 쓰지 않는다.
- 칸반 열 자체에는 단계 색을 칠하지 않는다(열 머리 배지 정도만). 카드 위의 "지연"·"담당자 퇴사" 표시가 묻히지 않게 하기 위해서다.
- 차트 막대끼리의 대비(발굴↔제안 1.99:1, 제안↔협상 1.59:1)는 3:1에 못 미친다. 막대 사이에 간격을 두고 각 막대에 단계 이름과 금액 라벨을 붙이는 것을 전제로 한다(7장).

#### Lead 상태 (`prd/02-lead.md` §3.2)

| 상태 | 토큰 | 진한 색 (점) | 배지 배경 | 배지 글자 |
|---|---|---|---|---|
| 신규 | `lead-new` | indigo-500 | indigo-50 | indigo-700 |
| 진행 중 | `lead-working` | violet-500 | violet-50 | violet-700 |
| 검증됨 | `lead-qualified` | teal-600 | teal-50 | teal-700 |
| 전환됨 | `lead-converted` | green-600 | green-50 | green-700 |
| 제외 | `lead-excluded` | neutral-400 | neutral-100 | neutral-600 |

근거:

- 열린 상태 셋(신규·진행 중·검증됨)은 서로 오갈 수 있어 순서가 고정되지 않는다(§3.2 전이 표). 그래서 명도 단계가 아니라 **서로 다른 색상**으로 구분한다.
- 검증됨은 청록: 전환 버튼이 켜지는 유일한 상태(`AC-LD-06`)라 "준비됨"을 눈에 띄게 한다. 상태 필터(`AC-LD-02`)에서 전환 후보를 바로 찾게 한다.
- 전환됨은 수주와 같은 초록: 둘 다 "흐름의 끝에서 성과로 넘어간 것"이다. Lead 화면과 Opportunity 화면에 함께 나오지 않으므로 혼동이 없다.
- 제외는 회색: 보류 상태(§3.2)이고 행동이 필요하지 않다.
- 신규는 발굴과 같은 색이다. 둘 다 깔때기의 입구이고, 두 배지가 한 화면에 함께 나오는 곳이 없다.

#### 활동 종류 (`prd/05-activity.md` `AC-AT-01`)

| 종류 | 토큰 | 아이콘 색 | 아이콘 배경 (원형) | 라벨 글자 |
|---|---|---|---|---|
| 통화 | `activity-call` | teal-600 | teal-50 | teal-700 |
| 미팅 | `activity-meeting` | violet-600 | violet-50 | violet-700 |
| 할 일 | `activity-task` | amber-600 | amber-50 | amber-700 |

근거:

- `AC-AT-08`의 타임라인은 활동과 단계 이력을 한 줄에 섞는다. 단계 이력 항목이 인디고(단계 색)이므로 활동 종류는 **인디고가 아닌 색**으로 둔다.
- 할 일은 호박색: 기한이 있는 유일한 종류(`AC-AT-01`)라 시계·마감을 연상시키는 따뜻한 색을 준다. 기한이 오늘이면 "오늘"(호박 채운 배지), 지나면 "지연"(빨강)이 덧붙는다(2.3 "그 밖의 상태 표시").
- 활동 종류는 배지가 아니라 **아이콘 + 라벨**로 그린다(1장 원칙 3). 그래서 Lead 상세에서 "진행 중" 배지(보라)와 "미팅" 아이콘(보라)이 함께 보여도 모양이 다르다.

#### 그 밖의 상태 표시

| 상태 | 근거 | 토큰 | 진한 색 | 배경 | 글자 | 결정 |
|---|---|---|---|---|---|---|
| 지연 | 할 일 `AC-AT-09`, Opportunity `AC-OP-19` `AC-DB-01` | `overdue` | red-600 | red-50 | red-700 | 배지 "지연". 날짜 텍스트도 `overdue-fg`로 바꾼다. 대시보드의 지연 건 수는 1 이상일 때만 `overdue-fg` |
| 오늘 기한 | 미완료 할 일 `AC-AT-09`, US-DB-4 | `due-today` | amber-600 | amber-700 (채움) | neutral-0 | 기한이 오늘인 미완료 할 일에 채운 배지 "오늘". 날짜 텍스트 색은 바꾸지 않는다 |
| 담당자 퇴사 | `AC-OP-25` | `owner-left` | amber-600 | amber-50 | amber-700 | 열린 Opportunity 카드·상세에 배지 "담당자 퇴사". 경고(확인 필요)이지 오류는 아니라서 호박색 |
| 준비 중 업종 | `AC-WS-12` | `coming-soon` | - | neutral-100 | neutral-600 | 배지 "준비 중". 항목 배경 `surface-muted`, 업종 이름·설명은 `fg-muted` |
| 수주율 계산 불가 | `AC-DB-03` | `unavailable` | - | - | neutral-500 | 수치 자리에 "—"를 `unavailable`로, 그 아래 설명을 `fg-muted`로 |
| Contact 퇴사 | `AC-CT-02` `AC-CT-07` `AC-AT-16` | `contact-left` | - | neutral-100 | neutral-600 | Contact 목록·상세·활동 대상 선택지에 배지 "퇴사". 재직 중은 배지 없이 `fg-muted` 글자 "재직 중" |

근거:

- **지연은 빨강**: 기한이 지나 지금 처리해야 하는 신호다. 대시보드는 "하루를 시작하는 화면"(US-DB-4)이라 지연 건이 먼저 눈에 들어와야 한다.
- **지연·오늘 판정**: 할 일 기한은 날짜만 가진다. 한국 시간 기준으로 기한 당일이면 "오늘", 기한 다음 날 0시부터 "지연"이다. Opportunity의 지연(예상 마감일 경과)도 같은 날짜 경계를 쓴다.
- **오늘 기한은 호박색 채운 배지**: 호박색은 이 문서에서 이미 "기한"을 뜻하는 색이다(할 일 종류 색). 오늘이 기한인 할 일은 그 뜻의 가장 강한 형태로, 기한이 지난 할 일은 빨강으로 넘어간다. 그래서 "기한 있음(호박 아이콘) → 오늘(호박 채운 배지) → 지연(빨강 배지)"이 한 줄의 강도 단계로 읽힌다. 지연(빨강)과는 색상이 달라 섞이지 않는다.
- **오늘 배지와 호박색이 겹치는 다른 표시의 구분**:
  - 할 일 종류 표시: 원형 아이콘 + 라벨이고 배지가 아니다(1장 원칙 3). "오늘"은 글자가 든 사각 배지(`rounded-sm`)이고 **배경을 채워**(amber-700 + 흰 글자) 연한 배경의 아이콘 원과 명도가 크게 다르다. 같은 할 일 행에 둘이 함께 나와도 모양·명도·글자로 구분된다.
  - 담당자 퇴사 배지: 같은 호박 계열이지만 연한 배경(amber-50)에 진한 글자다. "오늘"은 채운 배지라 명도가 반대다. 또 담당자 퇴사는 Opportunity에, 오늘은 할 일에만 붙어 한 항목에 함께 나오지 않는다.
  - 색만으로 구분하지 않는다: 두 배지는 항상 "오늘" / "담당자 퇴사" 글자를 가진다(WCAG 1.4.1).
- **담당자 퇴사는 호박색, Contact 퇴사는 회색**: 같은 "퇴사"라도 Contact 화면의 퇴사는 기록된 사실이고, 열린 Opportunity의 "담당자 퇴사"는 교체가 필요하다는 경고다(`AC-OP-25`, US-ACC-6). 종료된 Opportunity에는 표시하지 않는다(`AC-OP-25`).
- **준비 중 업종은 글자를 흐리게 하지 않는다**: WCAG는 비활성 컨트롤의 대비를 요구하지 않지만, 업종 15개를 "모두 보여 준다"(`AC-WS-12`)는 목적은 방문자가 나머지 업종도 읽게 하는 것이다. 그래서 글자 대비는 `fg-muted`(6.06:1)를 유지하고, 비활성은 회색 배경 + "준비 중" 배지 + 커서·hover 없음으로 전한다.
- **계산 불가는 "0%"처럼 보이지 않게**: `AC-DB-03`이 요구한다. 숫자 0 대신 "—"를 쓰고 색도 `fg`보다 흐린 `unavailable`로 둬서 "값이 없다"가 드러나게 한다. 설명 문구는 컴포넌트 스펙에서 정한다.

## 3. 타이포그래피

### 3.1 글꼴

```
"Pretendard Variable", Pretendard, -apple-system, BlinkMacSystemFont, system-ui,
"Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif
```

- Pretendard: 한글과 라틴·숫자의 굵기·높이가 고르게 맞춰진 오픈소스(SIL OFL 1.1) 글꼴. 가변 글꼴 하나로 400~700을 모두 쓴다. 불러오는 방식(자체 호스팅·동적 서브셋 등)은 frontend가 정한다.
- 대체 글꼴: macOS·iOS는 Apple SD Gothic Neo, Windows는 Malgun Gothic, 그 밖은 Noto Sans KR. 사용자가 Windows와 macOS를 모두 쓰므로 두 OS의 기본 한글 글꼴을 모두 넣었다.
- **숫자 정렬**: 금액, 건수, 날짜, 남은 시간은 `tabular-nums`(고정폭 숫자)로 쓴다. 칸반 열 머리 합계와 대시보드 수치가 바뀔 때 글자 폭이 흔들리지 않고, 표에서 자릿수가 세로로 맞는다.

### 3.2 크기

Tailwind 기본 이름과 크기를 그대로 두고 줄 높이·자간만 한글에 맞게 바꾼다. 이름이 익숙해 frontend가 따로 외울 것이 없다.

| 유틸리티 | 크기 | 줄 높이 | 자간 | 쓰임 |
|---|---|---|---|---|
| `text-xs` | 12px | 1.5 (18px) | 0 | 배지, 표 메타, 차트 축 |
| `text-sm` | 14px | 1.5 (21px) | 0 | **기본 본문**, 표, 칸반 카드, 버튼 |
| `text-base` | 16px | 1.5 (24px) | 0 | 입력란, 첫 화면 소개 문단 |
| `text-lg` | 18px | 1.45 | -0.01em | 섹션 제목, 모달 제목 |
| `text-xl` | 20px | 1.4 | -0.01em | 화면 제목 |
| `text-2xl` | 24px | 1.35 | -0.02em | 대시보드 요약 수치 |
| `text-3xl` | 30px | 1.3 | -0.02em | 대시보드 핵심 수치(수주율), 첫 화면 제목 |

- 기본 본문을 14px로 둔 이유: 칸반 카드 한 장에 이름·Account명·금액·마감일·상태 배지(`AC-OP-15` `AC-OP-19` `AC-OP-25`)가 들어가고, 목록 화면은 행이 많다. 16px이면 한 화면에 보이는 정보가 줄어든다.
- 입력란은 16px: iOS Safari는 16px 미만 입력란에 포커스하면 화면을 확대한다.
- 줄 높이 1.5: 한글은 받침 때문에 라틴 문자보다 줄 간격이 넉넉해야 읽기 편하다. 큰 제목은 줄 높이와 자간을 줄여 덩어리로 읽히게 한다.
- 12px 미만은 쓰지 않는다. 한글 12px 미만은 획이 뭉개진다.

### 3.3 굵기

| 유틸리티 | 값 | 쓰임 |
|---|---|---|
| `font-normal` | 400 | 본문 |
| `font-medium` | 500 | 라벨, 배지, 버튼, 표 머리 |
| `font-semibold` | 600 | 제목, 금액 |
| `font-bold` | 700 | 대시보드 핵심 수치 |

## 4. 간격·라운드·그림자

### 4.1 간격

Tailwind 기본 4px 단위(`--spacing: 0.25rem`)를 그대로 쓴다. 쓰는 단계를 아래로 제한해 화면마다 간격이 제각각이 되지 않게 한다.

| 유틸리티 숫자 | px | 쓰임 예 |
|---|---|---|
| `0.5` | 2 | 배지 세로 안쪽 여백 |
| `1` | 4 | 아이콘과 글자 사이 |
| `2` | 8 | 배지 가로 여백, 카드 안 줄 사이 |
| `3` | 12 | 칸반 카드 안쪽 여백, 칸반 카드 사이 |
| `4` | 16 | 카드·패널 안쪽 여백, 폼 필드 사이, 모바일 좌우 여백 |
| `6` | 24 | 섹션 사이 |
| `8` | 32 | 화면 상단 영역과 본문 사이 |
| `12` | 48 | 첫 화면 큰 구획 사이 |

4px 단위를 고른 이유: Tailwind 기본값이라 별도 학습이 없고, 14px 본문·21px 줄 높이와 조합해도 어긋남이 적다.

### 4.2 라운드

| 유틸리티 | 값 | 쓰임 |
|---|---|---|
| `rounded-sm` | 4px | 배지, 체크박스 |
| `rounded-md` | 6px | 버튼, 입력란, 드롭다운 항목 |
| `rounded-lg` | 8px | 카드, 칸반 카드, 칸반 열 |
| `rounded-xl` | 12px | 모달, 팝오버 |
| `rounded-full` | 원형 | 활동 종류 아이콘 배경, 범례 점 |

배지를 알약 모양(`rounded-full`)이 아니라 4px로 둔 이유: 활동 종류의 원형 아이콘과 모양으로 구분되게 하기 위해서다(1장 원칙 3).

### 4.3 그림자

그림자는 "위에 떠 있는 정도" 세 단계와 가장 약한 한 단계만 둔다. 다크 모드에서는 그림자 대신 표면 명도로 층을 구분하는 경우가 많아, 그림자도 의미 토큰(`--dt-shadow-*`)으로 두어 값을 바꿀 수 있게 했다.

| 유틸리티 | 값 | 쓰임 |
|---|---|---|
| `shadow-xs` | `0 1px 2px rgb(23 26 33 / 0.06)` | 칸반 카드, 카드 (평상시) |
| `shadow-sm` | `0 1px 3px rgb(23 26 33 / 0.10), 0 1px 2px rgb(23 26 33 / 0.06)` | 카드 hover |
| `shadow-md` | `0 4px 12px -2px rgb(23 26 33 / 0.12), 0 2px 4px -2px rgb(23 26 33 / 0.06)` | 드롭다운, 카드 메뉴, 끌고 있는 칸반 카드 |
| `shadow-lg` | `0 12px 32px -4px rgb(23 26 33 / 0.18), 0 4px 8px -4px rgb(23 26 33 / 0.08)` | 모달 |

카드의 경계는 그림자만이 아니라 `border-line` 테두리로도 그린다. 그림자가 약한 화면(밝은 모니터, 저품질 디스플레이)에서도 카드가 구분된다.

## 5. 표시 형식

### 5.1 금액 (`AC-COMMON-06`)

**선택: "5,000만 원" (만·억 단위 표기, 반올림 없음)**

규칙:

1. 금액(원, 0 이상 정수)을 뒤에서부터 네 자리씩 끊어 조·억·만 단위를 붙인다. 0인 단위는 생략한다.
2. 각 단위 앞 숫자는 천 단위 쉼표를 쓴다(`2,345만`).
3. 단위 사이는 한 칸 띄운다(한글 맞춤법 제44항, 수는 만 단위로 띄어 쓴다).
4. 마지막 네 자리가 0이 아니면 숫자에 "원"을 붙이고(`6,789원`), 0이면 마지막 단위 뒤에 한 칸 띄어 "원"을 쓴다(`5,000만 원`). 아라비아 숫자 뒤의 단위 명사는 붙여 쓸 수 있다(제43항).
5. 반올림·생략하지 않는다. 모든 자릿수가 그대로 남는다.
6. 0은 "0원".

| 값 | 표시 |
|---|---|
| 0 | 0원 |
| 5,500 | 5,500원 |
| 3,000,000 | 300만 원 |
| 50,000,000 | 5,000만 원 |
| 123,456,789 | 1억 2,345만 6,789원 |
| 500,000,000 | 5억 원 |
| 1,230,000,000 | 12억 3,000만 원 |

근거:

- **예시 데이터 금액대가 300만 ~ 5억**이다(`01` §3.4.1). "50,000,000원"(8자리)·"500,000,000원"(9자리)은 쉼표를 세어야 자릿수를 알 수 있다. 한국어 사용자는 금액을 "5천만", "5억"으로 읽으므로 그 읽는 방식대로 보여 주는 쪽이 빠르다.
- **칸반 카드 폭**: "5억 원"(4자)이 "500,000,000원"(12자)보다 훨씬 짧아 카드·열 머리 합계(`AC-OP-15`)에서 잘리지 않는다.
- **정확성을 잃지 않는다**: "50,000,000원" 방식의 장점은 정확한 값이다. 이 규칙은 반올림하지 않으므로 "1억 2,345만 6,789원"처럼 모든 자릿수를 남긴다. 대시보드 합계가 칸반 열 합계·개별 금액의 합과 같다는 것(`AC-DB-02` `AC-DB-05`)을 방문자가 화면에서 맞춰 볼 수 있다.
- 업종을 바꾸면 금액대가 달라 보여야 한다(`01` §3.4.1). "300만 원"과 "3억 원"은 단위 글자만으로 차이가 드러난다.

적용 범위와 예외:

- 칸반 카드, 열 머리 합계, Opportunity 상세, Account 상세의 Opportunity 목록, 대시보드, 전환 완료 안내 등 **금액을 보여 주는 모든 곳**에 이 형식 하나를 쓴다.
- **입력란은 예외**: 금액 입력(Opportunity 생성·수정 `AC-OP-01`, 전환 화면 `AC-LD-10`)은 숫자만 입력받고 천 단위 쉼표로 보여 준다("50,000,000" + 오른쪽에 "원"). 입력란 아래에 이 형식으로 읽은 값("5,000만 원")을 함께 보여 줘 자릿수 실수를 막는다. 만·억 단위로 직접 입력하게 하면 오히려 실수가 늘어난다.
- **차트 축 눈금**: 눈금 값은 "1억", "5,000만"처럼 단위만 쓰고 "원"을 뺀다(축 제목에 "금액(원)"). 눈금은 원래 딱 떨어지는 값이라 반올림이 생기지 않는다.
- 구현 주의: `Intl.NumberFormat('ko-KR', { notation: 'compact' })`는 "1.2억"처럼 **반올림**하므로 쓰지 않는다. 단위별 숫자의 쉼표에만 `Intl.NumberFormat('ko-KR')`을 쓴다.

### 5.2 날짜·시각

모든 날짜·시각은 **한국 시간(Asia/Seoul)** 으로 표시하고, "오늘"·"지연" 판정의 날짜 경계(0시)도 한국 시간이다. 방문자 브라우저의 시간대와 무관하다. 구현은 `Intl.DateTimeFormat('ko-KR', { timeZone: 'Asia/Seoul', ... })`처럼 시간대를 명시한다.

| 종류 | 형식 | 예 | 쓰는 곳 |
|---|---|---|---|
| 날짜 (올해) | `M월 D일` | 11월 12일 | 예상 마감일(`AC-OP-15`), 할 일 기한(`AC-AT-01` `AC-AT-09`) |
| 날짜 (다른 해) | `YYYY년 M월 D일` | 2027년 1월 5일 | 위와 같음 |
| 일시 | 날짜 + `오전/오후 h:mm` | 11월 12일 오후 2:30 | 통화·미팅 발생 시각, 단계 이력 시각(`AC-OP-11`), 대여 만료 시각 |
| 머문 기간 | 1분 미만 `1분 미만`, 1시간 미만 `N분`, 1일 미만 `N시간`, 그 이상 `N일` (모두 내림) | 제안 단계 1분 미만 / 12분 / 3시간 / 5일 | 단계 이력 타임라인(`AC-OP-13`) |
| 남은 시간 | `H시간 M분 남음`. 분이 0이면 `H시간 남음`, 1시간 미만은 `M분 남음`, 1분 미만은 `1분 미만 남음` | 23시간 12분 남음 / 1시간 남음 / 47분 남음 | 테스트 계정 남은 시간(`AC-COMMON-08`) |

**할 일 기한**: 할 일의 기한은 날짜만 가진다(시각 없음). 표시는 위 "날짜" 형식("11월 12일")이고, 시각을 붙이지 않는다. 판정은 한국 시간 기준으로:

| 조건 | 표시 |
|---|---|
| 기한 < 오늘 (기한 다음 날 0시부터) | 날짜 글자 `overdue-fg` + 배지 "지연" (`overdue`) |
| 기한 = 오늘 | 날짜 글자는 그대로 + 채운 배지 "오늘" (`due-today`) |
| 기한 > 오늘 | 날짜만 |

완료된 할 일에는 "오늘"·"지연"을 붙이지 않는다(`AC-AT-09`은 미완료 할 일 대상).

**머문 기간 단위**: 테스트 계정은 24시간짜리라, 방문자가 직접 옮긴 단계는 대부분 하루 안에 바뀐다. 일 단위만 쓰면 방문자가 만든 이력이 전부 같은 값("1일 미만")으로 보여 변화가 드러나지 않는다. 그래서 분 → 시간 → 일로 단위를 올리고, 각 단위 안에서는 내림한다(예: 59분 → "59분", 23시간 50분 → "23시간", 1일 23시간 → "1일"). 큰 단위 하나만 보이고 "1일 3시간"처럼 섞지 않는다. 타임라인 구간마다 짧은 길이로 같은 모양을 유지하기 위해서다.

**1분 미만은 "1분 미만"**: 방문자가 카드를 연달아 옮기면 몇 초짜리 구간이 생긴다. "0분"은 계산이 안 된 것처럼(또는 오류처럼) 보이고, "방금"은 시점을 말하는 표현이라 길이를 나타내는 다른 구간("12분", "3시간")과 나란히 놓이면 어색하다. 초 단위("8초")는 이 한 경우만을 위해 단위를 하나 더 늘린다. "1분 미만"은 실제로 머물렀다는 사실과 짧았다는 사실을 함께 전하면서 다른 구간과 같은 "길이" 표현을 유지한다.

**남은 시간 임박 표시**: 남은 시간이 **1시간 이하**(60분 0초 포함)가 되면 글자 색을 `fg-muted`에서 `warning-fg`로 바꾸고, 앞에 `warning` 색 경고 아이콘을 붙인다. 팝업·모달·소리는 두지 않는다. 만료 전 알림·연장은 MVP 범위 밖이므로(`prd/99-decisions-tbd.md` P6) 화면에 이미 있는 남은 시간 표시만 바꾼다. 색은 보조 수단이고, 남은 시간 글자("47분 남음") 자체가 뜻을 전한다. 회원 계정에는 이 표시가 없다(`AC-COMMON-08`).

| 상태 | 글자 | 아이콘 | 예 |
|---|---|---|---|
| 1시간 초과 | `fg-muted` | 없음 | 23시간 12분 남음 |
| 1시간 이하 | `warning-fg` | 경고 아이콘 `warning` | 1시간 남음, 47분 남음 |

근거:

- **"M월 D일"을 기본으로**: 예시 데이터 날짜가 작업 공간 생성 시각 기준이라(`AC-WS-20`) 대부분 올해 안이다. 연도를 매번 쓰면 카드가 길어지고, 한국어 화면에서 가장 자연스럽게 읽히는 형식이다. 연말에 생성하면 마감일이 다음 해로 넘어갈 수 있으므로, 그때만 연도를 붙인다.
- **"2026.11.12"나 "2026-11-12"를 쓰지 않는 이유**: 숫자만 이어진 날짜는 금액·건수와 섞여 보이고, 칸반 카드에서 금액 바로 옆에 놓이면 무엇이 날짜인지 한눈에 들어오지 않는다.
- **오전/오후 12시간제**: 한국어 UI의 일반적인 시각 표기다.
- **상대 표기("3일 전")를 기본으로 쓰지 않는다**: 단계 이력은 "언제 어느 단계를 거쳤는지"(US-OP-4)를 보는 기록이라 절대 시각이 기준이다. 상대 표기는 의미상 기간인 머문 기간과 남은 시간에만 쓴다.
- 지연 표시의 문구는 PRD 그대로 "지연"이다(`AC-OP-19` `AC-AT-09`).
- **한국 시간 고정**: 서버가 "오늘" 기준으로 지연 건을 센다(`AC-DB-01`, `06` §5). 화면이 브라우저 시간대를 따르면 해외에서 접속한 방문자에게 대시보드 지연 건 수와 카드의 "지연" 배지가 어긋날 수 있다. 표시와 판정을 한 시간대로 묶어 두 값이 항상 같게 한다.

### 5.3 비율·건수

| 종류 | 형식 | 예 |
|---|---|---|
| 건수 | `N건` | 3건 |
| 수주율 | 정수 % | 75% |
| 수주율 계산 불가 | "—" + 설명 | — (종료된 건이 없어 계산할 수 없음) |

수주율 소수점 처리: 소수 첫째 자리에서 반올림한 정수로 보이되, 실제 값이 0이 아니면 0%로, 1이 아니면 100%로 보이지 않게 1%~99% 안으로 맞춘다.

| 수주 · 실패 | 실제 값 | 표시 |
|---|---|---|
| 3 · 1 | 75% | 75% |
| 2 · 1 | 66.67% | 67% |
| 0 · 2 | 0% | 0% |
| 1 · 199 | 0.5% | 1% |
| 199 · 1 | 99.5% | 99% |
| 5 · 0 | 100% | 100% |
| 0 · 0 | 계산 불가 | — |

근거: "0%"와 "100%"는 "하나도 없음"과 "전부"라는 뜻으로만 쓰이게 한다. 단순 반올림이면 199·1이 "100%"로 보여 실패가 한 건도 없는 것처럼 읽힌다. 수주율 옆 기준 라벨 "종료 건 기준 · 건수"(`AC-DB-10`)는 `text-xs` `fg-muted`로 둔다.

### 5.4 전화번호

Lead·Contact의 전화번호(`AC-LD-01` `AC-CT-01`)는 저장된 번호를 그대로 보이되, 아래 형식으로 하이픈을 넣어 읽기 쉽게 한다. 이 절은 목록·상세 등 읽기 표시의 형식만 다룬다.

규칙:

1. 저장된 값에서 숫자만 뽑아 아래 표의 번호 종류를 판별하고, 그 종류의 묶음대로 하이픈을 넣는다. 저장 값에 하이픈이 없거나 공백·점으로 끊겨 있어도 표시는 같다.
2. 표에 맞지 않는 값(국제번호 `+82`, 내선 표기, 자릿수가 다른 값 등)은 **입력된 그대로** 보인다. 잘못 끊어 보이는 것보다 입력값을 그대로 두는 편이 정확하다.
3. 숫자는 `tabular-nums`로 쓴다(3.1).

| 종류 | 판별 (숫자만) | 저장 값 예 | 표시 |
|---|---|---|---|
| 휴대전화 | `010` + 8자리 | 01012345678 | 010-1234-5678 |
| 휴대전화 (옛 식별번호) | `011` `016` `017` `018` `019` + 7~8자리 | 0111235678 | 011-123-5678 |
| 서울 | `02` + 7~8자리 | 021235678 / 0212345678 | 02-123-5678 / 02-1234-5678 |
| 그 밖의 지역번호, 인터넷전화 | `03x`~`06x`, `070` + 7~8자리 | 0311235678 / 07012345678 | 031-123-5678 / 070-1234-5678 |
| 대표번호 | `15xx` `16xx` `18xx` 로 시작하는 8자리 | 15881234 | 1588-1234 |
| 판별 불가 | 위에 해당하지 않음 | +82 10 1234 5678 | +82 10 1234 5678 (그대로) |

근거:

- **형식을 정해 두는 이유**: 전화번호 필드의 입력 형식은 API 계약에서 정해지며(`AC-LD-01`), 하이픈 없이 저장될 수 있다. "01012345678"처럼 붙은 숫자는 자릿수를 세어야 읽힌다. 화면이 종류별 묶음으로 끊어 주면 입력 방식과 상관없이 같은 모양으로 보이고, 자릿수가 틀린 번호는 판별 불가로 떨어져 입력 그대로 보이므로 눈에 띈다.
- **`tabular-nums`**: 목록에서 같은 종류 번호끼리 하이픈 위치가 세로로 맞는다.
- 예시 데이터의 번호는 가상이다(`AC-WS-21`).
## 6. Tailwind 설정 (Tailwind CSS v4)

**v4 `@theme`를 고른 이유**: 새로 만드는 Next.js 프로젝트의 기본 Tailwind 버전이고, `@theme`의 토큰이 CSS 변수로 나와 다크 모드 값을 변수 재정의만으로 추가할 수 있다.

web 레포의 전역 CSS(예: `app/globals.css`)에 아래를 그대로 넣는다. `tailwind.config.js`는 필요 없다.

```css
@import "tailwindcss";

/* ─────────────────────────────────────────────
 * 1. 원시 팔레트
 *    유틸리티로 내보내지 않는다. 아래 의미 토큰만 이 값을 참조한다.
 * ───────────────────────────────────────────── */
:root {
  --dt-neutral-0: #FFFFFF;
  --dt-neutral-50: #F5F6F8;
  --dt-neutral-100: #ECEEF2;
  --dt-neutral-200: #DDE0E6;
  --dt-neutral-300: #C4C9D2;
  --dt-neutral-400: #878E9C;
  --dt-neutral-500: #646B79;
  --dt-neutral-600: #525967;
  --dt-neutral-700: #3D434F;
  --dt-neutral-800: #272C36;
  --dt-neutral-900: #171A21;

  --dt-indigo-50: #F1F0FE;
  --dt-indigo-100: #E3E1FC;
  --dt-indigo-200: #C9C5F8;
  --dt-indigo-300: #A7A1F2;
  --dt-indigo-400: #8079E8;
  --dt-indigo-500: #6159DB;
  --dt-indigo-600: #4C43C6;
  --dt-indigo-700: #3D35A6;
  --dt-indigo-800: #322C85;
  --dt-indigo-900: #28246A;

  --dt-violet-50: #F7F1FE;
  --dt-violet-500: #9A4FDB;
  --dt-violet-600: #8338C4;
  --dt-violet-700: #6E2BA6;

  --dt-teal-50: #EDFAF8;
  --dt-teal-600: #0D7C71;
  --dt-teal-700: #0B655D;

  --dt-green-50: #EEF9F1;
  --dt-green-600: #18823A;
  --dt-green-700: #146A30;

  --dt-amber-50: #FFF8EB;
  --dt-amber-600: #B26A05;
  --dt-amber-700: #8F5207;

  --dt-red-50: #FEF2F2;
  --dt-red-600: #C02929;
  --dt-red-700: #9E2121;
}

/* ─────────────────────────────────────────────
 * 2. 의미 토큰 (라이트 모드)
 *    다크 모드는 3번 자리에 같은 이름으로 값만 다시 정의한다.
 * ───────────────────────────────────────────── */
:root {
  color-scheme: light;

  /* 표면 */
  --dt-canvas: var(--dt-neutral-50);
  --dt-surface: var(--dt-neutral-0);
  --dt-surface-muted: var(--dt-neutral-100);
  --dt-surface-hover: var(--dt-neutral-50);
  --dt-surface-selected: var(--dt-indigo-50);
  --dt-overlay: rgb(23 26 33 / 0.5);

  /* 글자 */
  --dt-fg: var(--dt-neutral-900);
  --dt-fg-muted: var(--dt-neutral-600);
  --dt-fg-subtle: var(--dt-neutral-500);
  --dt-fg-disabled: var(--dt-neutral-400);
  --dt-fg-on-accent: var(--dt-neutral-0);
  --dt-fg-link: var(--dt-indigo-600);

  /* 선 */
  --dt-line: var(--dt-neutral-200);
  --dt-line-strong: var(--dt-neutral-400);
  --dt-focus: var(--dt-indigo-500);

  /* 동작 */
  --dt-accent: var(--dt-indigo-600);
  --dt-accent-hover: var(--dt-indigo-700);
  --dt-accent-bg: var(--dt-indigo-50);
  --dt-accent-fg: var(--dt-indigo-700);

  /* 피드백 */
  --dt-success: var(--dt-green-600);
  --dt-success-bg: var(--dt-green-50);
  --dt-success-fg: var(--dt-green-700);
  --dt-warning: var(--dt-amber-600);
  --dt-warning-bg: var(--dt-amber-50);
  --dt-warning-fg: var(--dt-amber-700);
  --dt-danger: var(--dt-red-600);
  --dt-danger-hover: var(--dt-red-700);
  --dt-danger-bg: var(--dt-red-50);
  --dt-danger-fg: var(--dt-red-700);
  --dt-info: var(--dt-indigo-600);
  --dt-info-bg: var(--dt-indigo-50);
  --dt-info-fg: var(--dt-indigo-700);

  /* Opportunity 단계 */
  --dt-stage-discovery: var(--dt-indigo-400);
  --dt-stage-discovery-bg: var(--dt-indigo-50);
  --dt-stage-discovery-fg: var(--dt-indigo-700);
  --dt-stage-proposal: var(--dt-indigo-600);
  --dt-stage-proposal-bg: var(--dt-indigo-100);
  --dt-stage-proposal-fg: var(--dt-indigo-800);
  --dt-stage-negotiation: var(--dt-indigo-800);
  --dt-stage-negotiation-bg: var(--dt-indigo-200);
  --dt-stage-negotiation-fg: var(--dt-indigo-900);
  --dt-stage-won: var(--dt-green-600);
  --dt-stage-won-bg: var(--dt-green-50);
  --dt-stage-won-fg: var(--dt-green-700);
  --dt-stage-lost: var(--dt-neutral-500);
  --dt-stage-lost-bg: var(--dt-neutral-100);
  --dt-stage-lost-fg: var(--dt-neutral-600);

  /* Lead 상태 */
  --dt-lead-new: var(--dt-indigo-500);
  --dt-lead-new-bg: var(--dt-indigo-50);
  --dt-lead-new-fg: var(--dt-indigo-700);
  --dt-lead-working: var(--dt-violet-500);
  --dt-lead-working-bg: var(--dt-violet-50);
  --dt-lead-working-fg: var(--dt-violet-700);
  --dt-lead-qualified: var(--dt-teal-600);
  --dt-lead-qualified-bg: var(--dt-teal-50);
  --dt-lead-qualified-fg: var(--dt-teal-700);
  --dt-lead-converted: var(--dt-green-600);
  --dt-lead-converted-bg: var(--dt-green-50);
  --dt-lead-converted-fg: var(--dt-green-700);
  --dt-lead-excluded: var(--dt-neutral-400);
  --dt-lead-excluded-bg: var(--dt-neutral-100);
  --dt-lead-excluded-fg: var(--dt-neutral-600);

  /* 활동 종류 */
  --dt-activity-call: var(--dt-teal-600);
  --dt-activity-call-bg: var(--dt-teal-50);
  --dt-activity-call-fg: var(--dt-teal-700);
  --dt-activity-meeting: var(--dt-violet-600);
  --dt-activity-meeting-bg: var(--dt-violet-50);
  --dt-activity-meeting-fg: var(--dt-violet-700);
  --dt-activity-task: var(--dt-amber-600);
  --dt-activity-task-bg: var(--dt-amber-50);
  --dt-activity-task-fg: var(--dt-amber-700);

  /* 그 밖의 상태 */
  --dt-overdue: var(--dt-red-600);
  --dt-overdue-bg: var(--dt-red-50);
  --dt-overdue-fg: var(--dt-red-700);
  --dt-due-today: var(--dt-amber-600);
  --dt-due-today-bg: var(--dt-amber-700);
  --dt-due-today-fg: var(--dt-neutral-0);
  --dt-owner-left: var(--dt-amber-600);
  --dt-owner-left-bg: var(--dt-amber-50);
  --dt-owner-left-fg: var(--dt-amber-700);
  --dt-coming-soon-bg: var(--dt-neutral-100);
  --dt-coming-soon-fg: var(--dt-neutral-600);
  --dt-contact-left-bg: var(--dt-neutral-100);
  --dt-contact-left-fg: var(--dt-neutral-600);
  --dt-unavailable: var(--dt-neutral-500);

  /* 그림자 */
  --dt-shadow-xs: 0 1px 2px rgb(23 26 33 / 0.06);
  --dt-shadow-sm: 0 1px 3px rgb(23 26 33 / 0.10), 0 1px 2px rgb(23 26 33 / 0.06);
  --dt-shadow-md: 0 4px 12px -2px rgb(23 26 33 / 0.12), 0 2px 4px -2px rgb(23 26 33 / 0.06);
  --dt-shadow-lg: 0 12px 32px -4px rgb(23 26 33 / 0.18), 0 4px 8px -4px rgb(23 26 33 / 0.08);
}

/* ─────────────────────────────────────────────
 * 3. 다크 모드 자리 (v0.1에서는 만들지 않는다)
 *    추가할 때 2번의 의미 토큰 이름 그대로 값만 다시 정의한다.
 *    화면 코드에 dark: 변형을 붙일 필요가 없다.
 *
 * :root[data-theme="dark"] {
 *   color-scheme: dark;
 *   --dt-canvas: ...;
 *   --dt-surface: ...;
 *   ...
 * }
 * ───────────────────────────────────────────── */

/* ─────────────────────────────────────────────
 * 4. Tailwind 테마: 값이 고정인 토큰
 * ───────────────────────────────────────────── */
@theme {
  /* Tailwind 기본 팔레트·크기·라운드·그림자를 끄고 아래 것만 쓴다 */
  --color-*: initial;
  --text-*: initial;
  --radius-*: initial;
  --shadow-*: initial;

  --font-sans: "Pretendard Variable", Pretendard, -apple-system, BlinkMacSystemFont,
    system-ui, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;

  --text-xs: 0.75rem;
  --text-xs--line-height: 1.5;
  --text-sm: 0.875rem;
  --text-sm--line-height: 1.5;
  --text-base: 1rem;
  --text-base--line-height: 1.5;
  --text-lg: 1.125rem;
  --text-lg--line-height: 1.45;
  --text-lg--letter-spacing: -0.01em;
  --text-xl: 1.25rem;
  --text-xl--line-height: 1.4;
  --text-xl--letter-spacing: -0.01em;
  --text-2xl: 1.5rem;
  --text-2xl--line-height: 1.35;
  --text-2xl--letter-spacing: -0.02em;
  --text-3xl: 1.875rem;
  --text-3xl--line-height: 1.3;
  --text-3xl--letter-spacing: -0.02em;

  --spacing: 0.25rem;

  --radius-sm: 0.25rem;
  --radius-md: 0.375rem;
  --radius-lg: 0.5rem;
  --radius-xl: 0.75rem;
}

/* ─────────────────────────────────────────────
 * 5. Tailwind 테마: 모드에 따라 바뀌는 토큰
 *    inline으로 두어 유틸리티가 var(--dt-*)를 직접 참조하게 한다.
 * ───────────────────────────────────────────── */
@theme inline {
  /* 표면 */
  --color-canvas: var(--dt-canvas);
  --color-surface: var(--dt-surface);
  --color-surface-muted: var(--dt-surface-muted);
  --color-surface-hover: var(--dt-surface-hover);
  --color-surface-selected: var(--dt-surface-selected);
  --color-overlay: var(--dt-overlay);

  /* 글자 */
  --color-fg: var(--dt-fg);
  --color-fg-muted: var(--dt-fg-muted);
  --color-fg-subtle: var(--dt-fg-subtle);
  --color-fg-disabled: var(--dt-fg-disabled);
  --color-fg-on-accent: var(--dt-fg-on-accent);
  --color-fg-link: var(--dt-fg-link);

  /* 선 */
  --color-line: var(--dt-line);
  --color-line-strong: var(--dt-line-strong);
  --color-focus: var(--dt-focus);

  /* 동작 */
  --color-accent: var(--dt-accent);
  --color-accent-hover: var(--dt-accent-hover);
  --color-accent-bg: var(--dt-accent-bg);
  --color-accent-fg: var(--dt-accent-fg);

  /* 피드백 */
  --color-success: var(--dt-success);
  --color-success-bg: var(--dt-success-bg);
  --color-success-fg: var(--dt-success-fg);
  --color-warning: var(--dt-warning);
  --color-warning-bg: var(--dt-warning-bg);
  --color-warning-fg: var(--dt-warning-fg);
  --color-danger: var(--dt-danger);
  --color-danger-hover: var(--dt-danger-hover);
  --color-danger-bg: var(--dt-danger-bg);
  --color-danger-fg: var(--dt-danger-fg);
  --color-info: var(--dt-info);
  --color-info-bg: var(--dt-info-bg);
  --color-info-fg: var(--dt-info-fg);

  /* Opportunity 단계 */
  --color-stage-discovery: var(--dt-stage-discovery);
  --color-stage-discovery-bg: var(--dt-stage-discovery-bg);
  --color-stage-discovery-fg: var(--dt-stage-discovery-fg);
  --color-stage-proposal: var(--dt-stage-proposal);
  --color-stage-proposal-bg: var(--dt-stage-proposal-bg);
  --color-stage-proposal-fg: var(--dt-stage-proposal-fg);
  --color-stage-negotiation: var(--dt-stage-negotiation);
  --color-stage-negotiation-bg: var(--dt-stage-negotiation-bg);
  --color-stage-negotiation-fg: var(--dt-stage-negotiation-fg);
  --color-stage-won: var(--dt-stage-won);
  --color-stage-won-bg: var(--dt-stage-won-bg);
  --color-stage-won-fg: var(--dt-stage-won-fg);
  --color-stage-lost: var(--dt-stage-lost);
  --color-stage-lost-bg: var(--dt-stage-lost-bg);
  --color-stage-lost-fg: var(--dt-stage-lost-fg);

  /* Lead 상태 */
  --color-lead-new: var(--dt-lead-new);
  --color-lead-new-bg: var(--dt-lead-new-bg);
  --color-lead-new-fg: var(--dt-lead-new-fg);
  --color-lead-working: var(--dt-lead-working);
  --color-lead-working-bg: var(--dt-lead-working-bg);
  --color-lead-working-fg: var(--dt-lead-working-fg);
  --color-lead-qualified: var(--dt-lead-qualified);
  --color-lead-qualified-bg: var(--dt-lead-qualified-bg);
  --color-lead-qualified-fg: var(--dt-lead-qualified-fg);
  --color-lead-converted: var(--dt-lead-converted);
  --color-lead-converted-bg: var(--dt-lead-converted-bg);
  --color-lead-converted-fg: var(--dt-lead-converted-fg);
  --color-lead-excluded: var(--dt-lead-excluded);
  --color-lead-excluded-bg: var(--dt-lead-excluded-bg);
  --color-lead-excluded-fg: var(--dt-lead-excluded-fg);

  /* 활동 종류 */
  --color-activity-call: var(--dt-activity-call);
  --color-activity-call-bg: var(--dt-activity-call-bg);
  --color-activity-call-fg: var(--dt-activity-call-fg);
  --color-activity-meeting: var(--dt-activity-meeting);
  --color-activity-meeting-bg: var(--dt-activity-meeting-bg);
  --color-activity-meeting-fg: var(--dt-activity-meeting-fg);
  --color-activity-task: var(--dt-activity-task);
  --color-activity-task-bg: var(--dt-activity-task-bg);
  --color-activity-task-fg: var(--dt-activity-task-fg);

  /* 그 밖의 상태 */
  --color-overdue: var(--dt-overdue);
  --color-overdue-bg: var(--dt-overdue-bg);
  --color-overdue-fg: var(--dt-overdue-fg);
  --color-due-today: var(--dt-due-today);
  --color-due-today-bg: var(--dt-due-today-bg);
  --color-due-today-fg: var(--dt-due-today-fg);
  --color-owner-left: var(--dt-owner-left);
  --color-owner-left-bg: var(--dt-owner-left-bg);
  --color-owner-left-fg: var(--dt-owner-left-fg);
  --color-coming-soon-bg: var(--dt-coming-soon-bg);
  --color-coming-soon-fg: var(--dt-coming-soon-fg);
  --color-contact-left-bg: var(--dt-contact-left-bg);
  --color-contact-left-fg: var(--dt-contact-left-fg);
  --color-unavailable: var(--dt-unavailable);

  /* 그림자 */
  --shadow-xs: var(--dt-shadow-xs);
  --shadow-sm: var(--dt-shadow-sm);
  --shadow-md: var(--dt-shadow-md);
  --shadow-lg: var(--dt-shadow-lg);
}

/* ─────────────────────────────────────────────
 * 6. 기본 스타일
 * ───────────────────────────────────────────── */
@layer base {
  html {
    font-family: var(--font-sans);
    background-color: var(--dt-canvas);
    color: var(--dt-fg);
  }
}
```

사용 예:

```html
<!-- 단계 배지 -->
<span class="rounded-sm bg-stage-won-bg px-2 py-0.5 text-xs font-medium text-stage-won-fg">수주</span>

<!-- 지연 배지 -->
<span class="rounded-sm bg-overdue-bg px-2 py-0.5 text-xs font-medium text-overdue-fg">지연</span>

<!-- 칸반 카드 -->
<article class="rounded-lg border border-line bg-surface p-3 text-sm shadow-xs hover:shadow-sm">
  <p class="font-medium text-fg">대양정밀 - 프레스 라인 베어링 연간 공급</p>
  <p class="text-fg-muted">대양정밀</p>
  <p class="font-semibold tabular-nums text-fg">1억 2,000만 원</p>
</article>

<!-- 기본 버튼 -->
<button class="rounded-md bg-accent px-4 py-2 text-sm font-medium text-fg-on-accent hover:bg-accent-hover
               focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus">
  체험하기
</button>
```

참고:

- `bg-transparent`, `bg-current`, `rounded-full`, `rounded-none`은 테마와 무관한 기본 유틸리티라 `--color-*: initial`, `--radius-*: initial` 뒤에도 그대로 쓸 수 있다.
- 범례 점·막대처럼 진한 색 토큰(`stage-won` 등)은 `bg-stage-won`, 아이콘은 `text-activity-call`처럼 쓴다.

## 7. WCAG AA 대비 확인

기준: 일반 텍스트 4.5:1 (1.4.3), UI 컴포넌트 경계·의미 있는 그래픽 3:1 (1.4.11). 대비는 WCAG 2.x 상대 휘도 공식으로 계산했다. 이 문서의 큰 글자(18px 굵게 이상)도 모두 일반 텍스트 기준 4.5:1로 확인했다.

| 조합 (전경 / 배경) | 쓰임 | 전경 | 배경 | 대비 | 기준 | 결과 |
|---|---|---|---|---|---|---|
| `fg / canvas` | 본문 | `#171A21` | `#F5F6F8` | 16.10:1 | 4.5:1 (텍스트) | 통과 |
| `fg / surface` | 본문 | `#171A21` | `#FFFFFF` | 17.41:1 | 4.5:1 (텍스트) | 통과 |
| `fg / surface-muted` | 칸반 열 머리 등 | `#171A21` | `#ECEEF2` | 14.99:1 | 4.5:1 (텍스트) | 통과 |
| `fg-muted / surface` | 보조 텍스트, "계산 불가" 설명 | `#525967` | `#FFFFFF` | 7.04:1 | 4.5:1 (텍스트) | 통과 |
| `fg-muted / canvas` | 보조 텍스트 | `#525967` | `#F5F6F8` | 6.51:1 | 4.5:1 (텍스트) | 통과 |
| `fg-muted / surface-muted` | 보조 텍스트, 준비 중 업종 이름·설명 | `#525967` | `#ECEEF2` | 6.06:1 | 4.5:1 (텍스트) | 통과 |
| `fg-subtle / surface` | placeholder, 메타 정보 | `#646B79` | `#FFFFFF` | 5.36:1 | 4.5:1 (텍스트) | 통과 |
| `fg-subtle / canvas` | 메타 정보 | `#646B79` | `#F5F6F8` | 4.95:1 | 4.5:1 (텍스트) | 통과 |
| `fg-subtle / surface-muted` | 메타 정보 | `#646B79` | `#ECEEF2` | 4.61:1 | 4.5:1 (텍스트) | 통과 |
| `fg-link / surface` | 링크 | `#4C43C6` | `#FFFFFF` | 7.18:1 | 4.5:1 (텍스트) | 통과 |
| `fg-link / canvas` | 링크 | `#4C43C6` | `#F5F6F8` | 6.64:1 | 4.5:1 (텍스트) | 통과 |
| `fg-link / surface-muted` | 링크 | `#4C43C6` | `#ECEEF2` | 6.18:1 | 4.5:1 (텍스트) | 통과 |
| `fg-on-accent / accent` | 기본 버튼 | `#FFFFFF` | `#4C43C6` | 7.18:1 | 4.5:1 (텍스트) | 통과 |
| `fg-on-accent / accent-hover` | 기본 버튼 hover | `#FFFFFF` | `#3D35A6` | 9.30:1 | 4.5:1 (텍스트) | 통과 |
| `accent-fg / accent-bg` | 보조 버튼, 선택 행 | `#3D35A6` | `#F1F0FE` | 8.25:1 | 4.5:1 (텍스트) | 통과 |
| `fg-on-accent / danger` | 위험 버튼(초기화) | `#FFFFFF` | `#C02929` | 5.85:1 | 4.5:1 (텍스트) | 통과 |
| `fg-on-accent / danger-hover` | 위험 버튼 hover | `#FFFFFF` | `#9E2121` | 7.80:1 | 4.5:1 (텍스트) | 통과 |
| `fg-disabled / surface-muted` | 비활성 컨트롤 | `#878E9C` | `#ECEEF2` | 2.83:1 | 해당 없음 (1.4.3 예외) | - |
| `line-strong / surface` | 입력란 테두리 | `#878E9C` | `#FFFFFF` | 3.29:1 | 3:1 (UI) | 통과 |
| `line-strong / canvas` | 입력란 테두리 | `#878E9C` | `#F5F6F8` | 3.04:1 | 3:1 (UI) | 통과 |
| `focus / surface` | 포커스 링 | `#6159DB` | `#FFFFFF` | 5.30:1 | 3:1 (UI) | 통과 |
| `focus / canvas` | 포커스 링 | `#6159DB` | `#F5F6F8` | 4.90:1 | 3:1 (UI) | 통과 |
| `focus / surface-muted` | 포커스 링 | `#6159DB` | `#ECEEF2` | 4.57:1 | 3:1 (UI) | 통과 |
| `line / surface` | 구분선 | `#DDE0E6` | `#FFFFFF` | 1.32:1 | 해당 없음 (장식) | - |
| `stage-discovery-fg / -bg` | 배지 "발굴" | `#3D35A6` | `#F1F0FE` | 8.25:1 | 4.5:1 (텍스트) | 통과 |
| `stage-proposal-fg / -bg` | 배지 "제안" | `#322C85` | `#E3E1FC` | 8.96:1 | 4.5:1 (텍스트) | 통과 |
| `stage-negotiation-fg / -bg` | 배지 "협상" | `#28246A` | `#C9C5F8` | 8.27:1 | 4.5:1 (텍스트) | 통과 |
| `stage-won-fg / -bg` | 배지 "수주" | `#146A30` | `#EEF9F1` | 6.21:1 | 4.5:1 (텍스트) | 통과 |
| `stage-lost-fg / -bg` | 배지 "실패" | `#525967` | `#ECEEF2` | 6.06:1 | 4.5:1 (텍스트) | 통과 |
| `stage-discovery / surface` | 차트 막대·점 | `#8079E8` | `#FFFFFF` | 3.61:1 | 3:1 (그래픽) | 통과 |
| `stage-proposal / surface` | 차트 막대·점 | `#4C43C6` | `#FFFFFF` | 7.18:1 | 3:1 (그래픽) | 통과 |
| `stage-negotiation / surface` | 차트 막대·점 | `#322C85` | `#FFFFFF` | 11.45:1 | 3:1 (그래픽) | 통과 |
| `stage-won / surface` | 점·아이콘 | `#18823A` | `#FFFFFF` | 4.89:1 | 3:1 (그래픽) | 통과 |
| `stage-lost / surface` | 점·아이콘 | `#646B79` | `#FFFFFF` | 5.36:1 | 3:1 (그래픽) | 통과 |
| `lead-new-fg / -bg` | 배지 "신규" | `#3D35A6` | `#F1F0FE` | 8.25:1 | 4.5:1 (텍스트) | 통과 |
| `lead-working-fg / -bg` | 배지 "진행 중" | `#6E2BA6` | `#F7F1FE` | 7.41:1 | 4.5:1 (텍스트) | 통과 |
| `lead-qualified-fg / -bg` | 배지 "검증됨" | `#0B655D` | `#EDFAF8` | 6.47:1 | 4.5:1 (텍스트) | 통과 |
| `lead-converted-fg / -bg` | 배지 "전환됨" | `#146A30` | `#EEF9F1` | 6.21:1 | 4.5:1 (텍스트) | 통과 |
| `lead-excluded-fg / -bg` | 배지 "제외" | `#525967` | `#ECEEF2` | 6.06:1 | 4.5:1 (텍스트) | 통과 |
| `lead-new / surface` | 점 | `#6159DB` | `#FFFFFF` | 5.30:1 | 3:1 (그래픽) | 통과 |
| `lead-working / surface` | 점 | `#9A4FDB` | `#FFFFFF` | 4.65:1 | 3:1 (그래픽) | 통과 |
| `lead-qualified / surface` | 점 | `#0D7C71` | `#FFFFFF` | 5.07:1 | 3:1 (그래픽) | 통과 |
| `lead-converted / surface` | 점 | `#18823A` | `#FFFFFF` | 4.89:1 | 3:1 (그래픽) | 통과 |
| `lead-excluded / surface` | 점 | `#878E9C` | `#FFFFFF` | 3.29:1 | 3:1 (그래픽) | 통과 |
| `activity-call / -bg` | 통화 아이콘 | `#0D7C71` | `#EDFAF8` | 4.74:1 | 3:1 (그래픽) | 통과 |
| `activity-meeting / -bg` | 미팅 아이콘 | `#8338C4` | `#F7F1FE` | 5.70:1 | 3:1 (그래픽) | 통과 |
| `activity-task / -bg` | 할 일 아이콘 | `#B26A05` | `#FFF8EB` | 4.01:1 | 3:1 (그래픽) | 통과 |
| `activity-call-fg / surface` | "통화" 라벨 | `#0B655D` | `#FFFFFF` | 6.92:1 | 4.5:1 (텍스트) | 통과 |
| `activity-meeting-fg / surface` | "미팅" 라벨 | `#6E2BA6` | `#FFFFFF` | 8.21:1 | 4.5:1 (텍스트) | 통과 |
| `activity-task-fg / surface` | "할 일" 라벨 | `#8F5207` | `#FFFFFF` | 6.22:1 | 4.5:1 (텍스트) | 통과 |
| `overdue-fg / overdue-bg` | 배지 "지연" | `#9E2121` | `#FEF2F2` | 7.13:1 | 4.5:1 (텍스트) | 통과 |
| `overdue-fg / surface` | 지연된 날짜 텍스트 | `#9E2121` | `#FFFFFF` | 7.80:1 | 4.5:1 (텍스트) | 통과 |
| `overdue / surface` | 지연 아이콘 | `#C02929` | `#FFFFFF` | 5.85:1 | 3:1 (그래픽) | 통과 |
| `due-today-fg / -bg` | 채운 배지 "오늘" | `#FFFFFF` | `#8F5207` | 6.22:1 | 4.5:1 (텍스트) | 통과 |
| `due-today / surface` | 오늘 기한 아이콘 | `#B26A05` | `#FFFFFF` | 4.24:1 | 3:1 (그래픽) | 통과 |
| `warning-fg / surface` | 남은 시간 1시간 이하 | `#8F5207` | `#FFFFFF` | 6.22:1 | 4.5:1 (텍스트) | 통과 |
| `warning-fg / canvas` | 남은 시간 1시간 이하 | `#8F5207` | `#F5F6F8` | 5.75:1 | 4.5:1 (텍스트) | 통과 |
| `warning-fg / surface-muted` | 남은 시간 1시간 이하 | `#8F5207` | `#ECEEF2` | 5.35:1 | 4.5:1 (텍스트) | 통과 |
| `warning / canvas` | 남은 시간 경고 아이콘 | `#B26A05` | `#F5F6F8` | 3.92:1 | 3:1 (그래픽) | 통과 |
| `owner-left-fg / -bg` | 배지 "담당자 퇴사" | `#8F5207` | `#FFF8EB` | 5.88:1 | 4.5:1 (텍스트) | 통과 |
| `owner-left / surface` | 경고 아이콘 | `#B26A05` | `#FFFFFF` | 4.24:1 | 3:1 (그래픽) | 통과 |
| `coming-soon-fg / -bg` | 배지 "준비 중" | `#525967` | `#ECEEF2` | 6.06:1 | 4.5:1 (텍스트) | 통과 |
| `contact-left-fg / -bg` | 배지 "퇴사" | `#525967` | `#ECEEF2` | 6.06:1 | 4.5:1 (텍스트) | 통과 |
| `unavailable / surface` | 수주율 자리 "—" | `#646B79` | `#FFFFFF` | 5.36:1 | 4.5:1 (텍스트) | 통과 |
| `success-fg / success-bg` | 성공 알림 | `#146A30` | `#EEF9F1` | 6.21:1 | 4.5:1 (텍스트) | 통과 |
| `warning-fg / warning-bg` | 경고 알림 | `#8F5207` | `#FFF8EB` | 5.88:1 | 4.5:1 (텍스트) | 통과 |
| `danger-fg / danger-bg` | 에러 알림, 거부 사유 | `#9E2121` | `#FEF2F2` | 7.13:1 | 4.5:1 (텍스트) | 통과 |
| `info-fg / info-bg` | 안내 | `#3D35A6` | `#F1F0FE` | 8.25:1 | 4.5:1 (텍스트) | 통과 |
| `danger-fg / surface` | 입력란 에러 문구 | `#9E2121` | `#FFFFFF` | 7.80:1 | 4.5:1 (텍스트) | 통과 |
| `success / surface` | 성공 아이콘 | `#18823A` | `#FFFFFF` | 4.89:1 | 3:1 (그래픽) | 통과 |
| `warning / surface` | 경고 아이콘 | `#B26A05` | `#FFFFFF` | 4.24:1 | 3:1 (그래픽) | 통과 |
| `danger / surface` | 에러 아이콘, 에러 입력란 테두리 | `#C02929` | `#FFFFFF` | 5.85:1 | 3:1 (UI) | 통과 |
| `info / surface` | 안내 아이콘 | `#4C43C6` | `#FFFFFF` | 7.18:1 | 3:1 (그래픽) | 통과 |

### 7.1 여유가 적거나 조건이 붙는 조합

| 조합 | 대비 | 조건 |
|---|---|---|
| `line-strong / canvas` | 3.04:1 | 기준을 겨우 넘는다. 입력란은 `surface`(3.29:1) 위에 두는 것을 기본으로 한다 |
| `fg-subtle / surface-muted` | 4.61:1 | 기준을 겨우 넘는다. 회색 배경 위의 메타 정보는 가능하면 `fg-muted`(6.06:1)를 쓴다 |
| `warning`·`activity-task`·`owner-left`·`due-today` (amber-600) / `surface` | 4.24:1 | 아이콘(3:1)으로만 통과한다(`canvas` 위 3.92:1). **글자에 쓰면 4.5:1 미달**이므로 글자는 반드시 `-fg`(amber-700, 6.22:1)를 쓴다. `due-today`만 예외로 `-fg`가 흰색이고 배경이 amber-700이다 |
| `due-today-bg`(amber-700) 배지 / `overdue-bg`·`overdue-fg` | - | "오늘"과 "지연"은 한 할 일에 동시에 붙지 않는다(기한 = 오늘이거나 기한 < 오늘). 색상(호박 vs 빨강)과 채움(채움 vs 연함)이 모두 달라 목록에서 섞여 보여도 구분된다 |
| `stage-discovery` (indigo-400) / `surface` | 3.61:1 | 막대·점으로만 쓴다. 글자에 쓰지 않는다 |
| 차트 막대끼리 (발굴↔제안 1.99:1, 제안↔협상 1.59:1) | 3:1 미만 | 막대를 맞붙이지 않고 간격을 두며, 각 막대에 단계 이름과 금액을 글자로 표시한다(색 구분에 의존하지 않음, 1.4.1). 쌓은 막대·깔때기처럼 색끼리 맞닿는 형태를 쓰면 경계에 `surface` 색 1px 간격을 둔다 |
| `fg-disabled / surface-muted` | 2.83:1 | 비활성 컨트롤은 1.4.3 예외다. 단, 준비 중 업종처럼 **읽혀야 하는** 비활성 항목에는 쓰지 않는다(2.3) |
| `lead-new` = `stage-discovery` 배지, `lead-converted` = `stage-won` 배지 | - | 의도적으로 같은 색이다. 두 배지가 한 화면에 함께 나오는 곳이 없다(전환 화면에도 Lead 상태 배지와 단계 배지를 나란히 두지 않는 것을 전제로 한다) |
