Table of Contents
=================
  
- [Overview](#overview)  
- [Download](#download)  
- [How to Use](#how-to-use)  
- [Copyright](#copyright)  
  
OverView  
=========

### Introduction

개발팀이 개발한 제품의 빌드 산출물에 대해서 OS 환경에 맞는 오픈소스 검증 스크립트를 통해 오픈소스를 검증하고 검증 결과를 Black Duck Hub에 등록합니다.  
  
프로젝트 버전이 이미 10개 등록된 상태에서 새로운 버전을 등록할 경우 가장 오래된 버전을 삭제하고 새로운 버전을 등록합니다.  
분석 폴더의 크기가 5GB 이상일 경우, 폴더를 5GB 이하로 분리하여 각각의 폴더를 별도로 분석합니다.  
프로젝트의 버전을 생성 시, Black Duck Hub의 지정된 custom field의 값을 특정 값으로 초기화 합니다.  

### Presetup

Presetup 내용은 OSS 관리자용입니다.
일반 사용자는 참조하지 않습니다.

#### detect jar 설치

본 스크립트는 detect-10.5.0.jar를 포함하고 있습니다. (Black Duck v2025.4.1 버전 지원)
blackduck-opensource-scanner.jar 에서 해당 jar파일을 자동으로 인식하기 위해서 파일명을 synopsys-detect-10.5.0.jar 로 파일명을 변경하였습니다.
이후 새로운 버전의 detect jar파일을 포함할 경우 파일명앞에 "synopsys-"를 붙여야 합니다.

#### packaged-inspectors 폴더 설치

본 스크립트는 air-gap 모드를 지원합니다.
고로 Black Duck 제조사에서 제공하는 packaged-inspectors를 포함합니다.
단, github의 파일 크기 제한으로 docker 폴더는 제거되었습니다.
이후 새로운 버전의 packaged-inspectors가 제공되면 해당 폴더에 복사해야 합니다.

#### Signature Scanner 설치
  
본 스크립트는 사용자가 host에 java를 설치하지 않아도 되도록 scan.cli-2024.7.3 (Signature Scanner)툴에 포함된 jvm을 포함하고 있습니다.  
예) blackduck-detect-for-windows\output\tools\Black_Duck_Scan_Installation\scan.cli-0.1.4\jre\bin\java

Black Duck Hub에서 제공하는 scan.cli 툴을 직접 복사하지 않고 해당 툴에 포함된 scan.cli-0.1.4\lib 폴더를 해당 스크립트의 
blackduck-detect-for-windows\output\tools\Black_Duck_Scan_Installation\scan.cli-0.1.4\lib 폴더에 overwrite 합니다.
이유는 macOS의 경우 Black Duck Hub에서 제공하는 scan.cli 이하에 포함된 java 실행파일이 링크가 걸려 있어서 복사하는 경우 제대로 실행되지 않기 때문에 스크립트에 포함된 java를 이용하기 위함입니다.
alpine linux는 Black Duck Hub에서 제공하지 않지만 alpine용 java를 별도로 구성한 경우입니다.

다음은 예시입니다.
  
1) 만약 Black Duck Hub 버전이 번경되어 scan.cli-0.1.4 툴이 버전업 되면 해당 버전의 Signature Scanner를 다음 메뉴에서 다운로드 받아 주십시오.  
Black Duck Hub > System > Tools > Legacy Downloads) > Download for Windows  
  
2) 다운로드 받은 Signature Scanner를 압축해제 합니다.  (예, scan.cli_0.1.4_windows.zip)

3) Scanner의 폴더명을 확인합니다. (예, scan.cli-0.1.4)

4) 기존 스크립트의 scanner 폴더명을 변경합니다. (to scan.cli-0.1.4)

5) 압축해제된 폴더에서 scan.cli-0.1.4\lib 폴더를 스크립트의 scan.cli-0.1.4/lib 폴더로 복사합니다. (overwrite)
blackduck-detect-for-windows\output\tools\Black_Duck_Scan_Installation\scan.cli-0.1.4
  
6) 새로 설치한 Signature Scanner 버전을 다음 파일에 명기합니다.
blackduck-detect-for-windows\output\tools\Black_Duck_Scan_Installation\blackDuckVersion.txt
상기 파일에 기존 버전정보를 지우고 새로운 버전을 입력합니다.
0.1.4

7) 다음 배치 파일에 Sinagnature Scanner의 위치를 변경합니다.
blackduck-detect-for-windows\scan_windows_online.bat
--scan.cli.path=%SHELL_PATH%\output\tools\Black_Duck_Scan_Installation\scan.cli-0.1.4

8) 만약 스크립트 실행 시, java 실행에 문제가 있을 경우 각 플랫폼에서 실행이 확인된 java를 jre 폴더에 설치합니다.
blackduck-detect-for-windows\output\tools\Black_Duck_Scan_Installation\scan.cli-0.1.4\jre

### Components

- DeleteVersion-1.0.0-jar-with-dependencies.jar  
  프로젝트에 이미 10개의 버전이 존재하고 새로운 버전의 스캔 결과를 Black Duck Hub에 등록하려 할 때 가장 오래된 버전을 삭제합니다.  
  Java로 개발되었으며 소스코드 저장소는 다음과 같습니다.
  https://github.com/AhnLab-OSSG/blackduck-delete-oldest.git

- blackduck-opensource-scanner.jar  
  빌드 산출물의 경로가 주어지면 오픈소스를 검증할 수 있는 5GB 이하의 작은 폴더 단위로 분리하고  
  각 폴더에 대해서 synopsys-detect.jar를 실행합니다.  
  Kotlin으로 개발되었으며 소스코드 저장소는 다음과 같습니다.
  https://github.com/AhnLab-OSSG/blackduck-opensource-scanner.git

- synopsys-detect.jar
  빌드 산출물에 대해 오픈소스를 검증하고 검증 결과를 Black Duck Hub에 등록합니다.
  해당 jar 파일은 Black Duck에서 제공하는 파일입니다.

- InitCustomerField-1.0.0-jar-with-dependencies.jar
  프로젝트의 버전을 생성 시, Black Duck Hub의 지정된 custom field의 값을 특정 값으로 초기화 합니다.
  Java로 개발되었으며 소스코드 저장소는 다음과 같습니다.
  https://github.com/AhnLab-OSSG/blackduck-init-custom-fields.git

  자세한 사용법은 "How to use Black Duck Scanner more easily.pdf" 를 참조해주십시오.

Download
=========

빌드 머신의 OS 환경에 따라서 REPOS로부터 저장소를 다운로드받을 수 있습니다.

|    OS 환경     | 소스 코드 저장소                                                                                                                      |
|:------------:|--------------------------------------------------------------------------------------------------------------------------------------|
|   windows    | [blackduck-detect-for-windows](https://github.com/AhnLab-OSSG/blackduck-detect-for-windows)                     |
|    linux     | [blackduck-detect-for-linux](https://github.com/AhnLab-OSSG/blackduck-detect-for-linux)                         |
| alpine linux | [blackduck-detect-for-linux](https://github.com/AhnLab-OSSG/blackduck-detect-for-alpine-linux)                         |
| macos-arm_64 | [blackduck-detect-for-macos-arm_64](https://github.com/AhnLab-OSSG/blackduck-detect-for-macos-arm_64)           |
| macos-x64 | [blackduck-detect-for-macos-x64](https://github.com/AhnLab-OSSG/blackduck-detect-for-macos-x64) |

또는 빌드 머신에서 아래의 명령어를 통해 REPOS에서 저장소를 다운로드받을 수 있습니다.

    git clone https://repos.ahnlab.com/scm/open/{{소스 코드 저장소}}.git

How to Use
=========

### 1. 최신 릴리즈 버전 다운로드

OS 환경에 따라 REPOS에서 최신 릴리즈 버전을 다운로드 받습니다.

### 2. 실행 스크립트 선택

빌드 머신의 OS 환경에 따라 실행할 스크립트를 선택합니다. 

| OS 환경       | 기본 스크립트             |
|--------------|-------------------------|
| windows      | scan_windows_online.bat |
| linux        | scan_linux_online.sh    |
| alpine linux | scan_linux_online.sh    |
| macos-x86_64 | scan_linux_online.sh    |
| macos-arm_64 | scan_linux_online.sh    |

### 3. 스크립트 실행

#### 3.1. 스크립트 폴더로 이동

    cd ~/blackduck-detect-for-$OS

#### 3.2. 실행 옵션 설정

3.2.1. 스크립트 실행 명령어 Format

    ./{{ 실행 스크립트}} {{ PROJECT }} {{ VERSION }} {{ SCAN_FOLDER }} {{ API_TOKEN }} {{ EXCLUDED_FOLDERS }} {{ DEPENDENCY }}

스크립트 예시

    ./scan_windows_online.bat "Test Project" "1.0.0" "D:\work\test_project" "BLACK_DUCK_API_TOKEN" "build, lib\external_lib" "true"

| KEY              | DESCRIPTION         | EXAMPLE                                              | CAUTION                                                                                                                              |
|------------------|---------------------|------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| PROJECT          | 프로젝트명            | Test Project                                        | 공백 포함 시 "(쌍따옴표)로 감싸야 합니다                                                                                                             |
| VERSION          | 프로젝트 버전명        | 1.0.0                                               | 공백 포함 시 "(쌍따옴표)로 감싸야 합니다                                                                                                             |
| SCAN_FOLDER      | 빌드 산출물 root 경로  | D:\work\test_project                                | 폴더명에 공백 혹은 툭수문자가 포함되면 안됩니다                                                                                                           |
| API_TOKEN        | BLACKDUCK API TOKEN | 시스템 담당자에게 문의                                  | 시스템 담당자에게 문의                                                                                                                       |
| EXCLUDED_FOLDERS | 검증에서 제외할 폴더명   | build, lib\external_lib      | 1. 제외할 폴더는 SCAN_FOLDER 기준으로 **상대 경로**로 작성해야 합니다.<br/>2. 제외할 폴더가 여러 개 있을 경우 공백 없이 ,(콤마)로만 연결합니다.<br/>3. 제외할 폴더가 없을 경우 ""(빈칸)으로 입력합니다. |
| DEPENDENCY       | DEPENDENCY 적용 여부    | "true" or "false"                                    | maven, gradle 같이 dependency를 적용할 경우 true, 그렇지 않으면 false를 입력합니다.                                                                      |

