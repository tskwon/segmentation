function process_text_file(inputPath, outputPath)
    % TXT 파일을 읽고 간단하게 처리하는 MATLAB 함수
    %
    % 입력:
    %   inputPath - 입력 TXT 파일 경로
    %   outputPath - 출력 결과 저장 경로
    
    % 기본 인수 설정
    if nargin < 1
        inputPath = "../data/raw/test_data.txt";
    end
    
    if nargin < 2
        outputPath = "../models/matlab/processed_data.mat";
    end
    
    % 시작 메시지 출력
    disp("=== MATLAB 텍스트 파일 처리 시작 ===");
    disp("입력 파일: " + inputPath);
    disp("출력 파일: " + outputPath);
    
    % 파일 존재 확인
    if ~exist(inputPath, 'file')
        error("입력 파일을 찾을 수 없습니다: " + inputPath);
    end
    
    % 출력 디렉토리 생성
    [outputDir, ~, ~] = fileparts(outputPath);
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % 파일 읽기
    disp("파일 읽는 중...");
    fileContent = fileread(inputPath);
    disp("파일 내용:");
    disp(fileContent);
    
    % 파일 내용 파싱 (숫자 데이터 추출)
    disp("숫자 데이터 추출 중...");
    lines = strsplit(fileContent, '\n');
    
    % 숫자 데이터를 담을 행렬
    numbers = [];
    
    % 각 줄을 처리
    for i = 1:length(lines)
        line = lines{i};
        % "Line X: " 형식의 줄에서 숫자 추출
        if contains(line, "Line")
            % 콜론 이후의 부분 추출
            parts = strsplit(line, ':');
            if length(parts) >= 2
                % 두 번째 부분에서 숫자 추출
                numStr = strtrim(parts{2});
                nums = str2num(numStr); %#ok<ST2NM>
                
                % 숫자 배열에 추가
                if ~isempty(nums)
                    numbers = [numbers; nums]; %#ok<AGROW>
                end
            end
        end
    end
    
    % 결과 출력
    disp("추출된 숫자 데이터:");
    disp(numbers);
    
    % 간단한 계산 수행 (평균, 합계, 표준편차)
    results = struct();
    if ~isempty(numbers)
        results.data = numbers;
        results.mean = mean(numbers, 'all');
        results.sum = sum(numbers, 'all');
        results.std = std(numbers(:));
        results.timestamp = datetime('now');
        
        disp("계산 결과:");
        disp("  평균: " + results.mean);
        disp("  합계: " + results.sum);
        disp("  표준편차: " + results.std);
    else
        disp("숫자 데이터가 없습니다.");
    end
    
    % 결과 저장
    disp("결과 저장 중...");
    save(outputPath, 'results');
    
    % "최적화된" 결과도 생성 (TFLite 대신 텍스트 파일로 시뮬레이션)
    optimizedDir = "../models/optimized";
    if ~exist(optimizedDir, 'dir')
        mkdir(optimizedDir);
    end
    
    % 간단한 텍스트 파일로 최적화된 결과 시뮬레이션
    optimizedPath = fullfile(optimizedDir, 'simulated_model.tflite');
    fid = fopen(optimizedPath, 'w');
    fprintf(fid, "MATLAB 처리 결과 시뮬레이션\n");
    fprintf(fid, "생성 시간: %s\n", char(datetime('now')));
    fprintf(fid, "데이터 평균: %.2f\n", results.mean);
    fprintf(fid, "데이터 합계: %.2f\n", results.sum);
    fprintf(fid, "데이터 표준편차: %.2f\n", results.std);
    fprintf(fid, "행 수: %d\n", size(numbers, 1));
    fprintf(fid, "열 수: %d\n", size(numbers, 2));
    fclose(fid);
    
    disp("최적화된 결과 저장됨: " + optimizedPath);
    disp("=== MATLAB 처리 완료 ===");
end