# usage: mk_feat KEY EPIC "배경문" "선행" "설명 포인트" "유저 스토리" "인수조건" "구현 시 결정할 것(빈 문자열 가능)" "PRD" "API 계약" ["비고"]
mk_feat() {
  local decide=""
  if [ -n "$8" ]; then decide="
## 구현 시 결정할 것 (ADR 소재)

$8
"; fi
  local note=""
  if [ -n "${11}" ]; then note="
## 비고

${11}
"; fi
  cat > "$1.md" <<EOT
## 배경

$3

- Epic: {{$2}}
- 선행: $4
- 설명 포인트: $5

## 유저 스토리

$6

## 인수조건

$7
$decide$note
## 관련 문서

- PRD: $9
- 디자인: \`design/\` (화면 스펙이 생기면 링크)
- API 계약: ${10}
EOT
}
