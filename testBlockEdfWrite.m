function testBlockEdfWrite()
% testBlockEdfWrite. Test function for block EDF write that write to and 
% edf file.  The initial objective of the funciton is to write changes to
% the file in place, rather than copy. This funciton is necesitated by the 
% need to deidentify thousand of EDF files.  Which should be a quick
% operations.
%
% The function is geared towards researchers who need to modify edf
% information or to create new EDF's.  Generated signals might be stored in 
% an edf folder 
%
% Our EDF tools can be found at:
%
%                  http://sleep.partners.org/edf/
%
% Function prototype:
%    status = blockEdfWrite(edfFN)
%
% Test files:
%     The test files are from the  from the EDF Browser website and the 
% Sleep Heart Health Study (SHHS) (see links below). The first file is
% a generated file and the SHHS file is from an actual sleep study.
%
% External Reference:
%
%   test_generator.edf (EDF Browswer Website)
%   http://www.teuniz.net/edf_bdf_testfiles/index.html
%
%   201434.EDF
%   https://sleepepi.partners.org/hybrid/
%
%
% Version: 0.1.06
%
% ---------------------------------------------
% Dennis A. Dean, II, Ph.D
%
% Program for Sleep and Cardiovascular Medicine
% Brigam and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% File created: October 23, 2012
% Last update:  November 21, 2013 
%    
% Copyright © [2013] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND,2 EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%

% Test Files
edfFn1 = 'AD122A_write_ex2.EDF';    % Test file with random header
edfFn2 = 'test_generator.edf';      % Test with small simulated file

% Test flags
RUN_TEST_1 =  0;   % Load file and change study date
RUN_TEST_2 =  0;   % Write signal header in place
RUN_TEST_3 =  0;   % Write signals in place
RUN_TEST_4 =  0;   % Check we can write to new file
RUN_TEST_5 =  0;   % Create a new file from a simulated dataset
RUN_TEST_6 =  0;   % Deidentify EDF, add function to write script file
RUN_TEST_7 =  0;   % Verify write, with no changes
RUN_TEST_8 =  1;   % Test deidentify functionality

% ------------------------------------------------------------------ Test 1
% Test 1: Load File and write header
if RUN_TEST_1 == 1
    % Write test results to console
    fprintf('------------------------------- Test 1\n\n');
    fprintf('Load and plot generated file\n\n');
    
    % Get header from file
    [header signalHeader ] = blockEdfLoad(edfFn1);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    % Change header date
    tic 
        header.recording_startdate = '01.02.02';
        status = blockEdfWrite(edfFn1, header);
    elapseTime = toc;
    
    % Echo deidentifiying time to data
    fprintf('\nTime to change date: %0.4f\n', elapseTime);
    fprintf('\nNumber of bytes written: %0.3f\n\n', status);
    
    % Get header from file
    header = blockEdfLoad(edfFn1);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    % Change header date
    header.recording_startdate = '12.04.06';
    blockEdfWrite(edfFn1, header);
end
% ------------------------------------------------------------------ Test 2
% Test 2: Load File and write header
if RUN_TEST_2 == 1
    % Write test results to console
    fprintf('------------------------------- Test 2\n\n');
    fprintf('Write signal header in place\n\n');
    
    % Get header from file
    [header signalHeader signalCell] = blockEdfLoad(edfFn1);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader, signalCell);

    % Change header date
    tic 
        header.recording_startdate = '01.02.02';
        status = blockEdfWrite(edfFn1, header, signalHeader);
    elapseTime = toc;
    
    % Echo deidentifiying time to data
    fprintf('\nTime to write header and signal header: %0.4f\n\n', elapseTime);
    fprintf('\nNumber of bytes written: %0.3f\n\n', status);
    
    % Get header from file
    header = blockEdfLoad(edfFn1);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    
    % Change header date
    header.recording_startdate = '12.04.06';
    blockEdfWrite(edfFn1, header);
end

% ------------------------------------------------------------------ Test 3
% Test 3: Load File and write header
if RUN_TEST_3 == 1
    % Write test results to console
    fprintf('------------------------------- Test 3\n\n');
    fprintf('Write signals in place\n\n');
    
    % Set display limits
    tmax = 60;
    figPosition = [-1919, 1, 1920, 1004];
    
    % Get header from file
    [header signalHeader signalCell] = blockEdfLoad(edfFn2);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
    
    % Change file contents
    tic 
        header.recording_startdate = '01.02.02';
        status = blockEdfWrite(edfFn2, header, signalHeader, signalCell);
    elapseTime = toc;
    
    % Load file contents
    [header signalHeader signalCell] = blockEdfLoad(edfFn2);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
    
    % Echo deidentifiying time to data
    fprintf('\nTime to write edf: %0.4f\n', elapseTime);
    fprintf('Number of bytes written: %0.3f\n\n', status);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
    

    
    % Change header date
    header.recording_startdate = '12.04.06';
    blockEdfWrite(edfFn1, header);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
end
% ------------------------------------------------------------------ Test 3
% Test 4: Load File and write header
if RUN_TEST_4 == 1
    % Write test results to console
    fprintf('------------------------------- Test 4\n\n');
    fprintf('Create a second edf from the first\n\n');
    
    % Function
    edfFnOut = 'test_generator2.edf';
    
    % Set display limits
    tmax = 60;
    figPosition = [-1919, 1, 1920, 1004];
    
    % Get header from file
    [header signalHeader signalCell] = blockEdfLoad(edfFn2);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
    signalCell1 = signalCell;
    % Change file contents
    tic 
        header.recording_startdate = '01.02.02';
        status = blockEdfWrite(edfFnOut, header, signalHeader, signalCell);
    elapseTime = toc;
    
    % Load file contents
    [header signalHeader signalCell] = blockEdfLoad(edfFnOut);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
    
    % Echo deidentifiying time to data
    fprintf('\nTime to write edf: %0.4f\n', elapseTime);
    fprintf('Number of bytes written: %0.3f\n\n', status);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
    
    % Change header date
    header.recording_startdate = '12.04.06';
    blockEdfWrite(edfFn1, header);
    fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
end
% ------------------------------------------------------------------ Test 3
% Test 5: Create a new file from a simulated dataset
if RUN_TEST_5 == 1
    % Write test results to console
    fprintf('------------------------------- Test 5\n\n');
    fprintf('Create a new file from a simulated dataset\n\n');
    
    % Output file name
    edfFnOut = 'test_generator_hiRes.edf';
        
    % Set display limits
    tmax = 60;
    figPosition = [-1919, 1, 1920, 1004];
    
    %------------------------------------------- Generate Artifical Signals
    % Generate signals
    sgObj = signalGeneratorClass;
    
    % Generate signal from 'test_generator.edf'
    % obj.sinusoid(A, f, SR, D)
    % signal parameters
    A = 100;  % Signal Amplitude
    f = 1.0;  % Signal Frequency
    SR = 500; % Sampling Rate (Hz)
    D = 450;  % Duration (sec)
    
    % Generate
    [t yC4 signalParamC4] = sgObj.sinusoid(A, 1.0, SR, D);
    [t yP3 signalParamP3] = sgObj.sinusoid(A, 8.0, SR, D);
    [t yC3 signalParamC3] = sgObj.sinusoid(A, 8.5, SR, D);
    [t yX9 signalParamX9] = sgObj.sinusoid(A, 15.0, SR, D);
    [t yFP1 signalParamFP1] = sgObj.sinusoid(A, 17.0, SR, D);
    y = [yC4 yP3 yC3 yX9 yFP1];
    
    % Signal Parameters
    signalLabels = {'yC4' 'yP3' 'yC3' 'yX9' 'yFP1'};
    A = [100 100 100 100 100 100];
    f = [ 1.0 8.0 8.5 15.0 17.0];
    SR = [ 500 500 500 500 500];
    D = [ 450 450 450 450 450];
    
    numSignals = length(signalLabels);
    
    % Plot figures overlapping
    t = [t t t t t];
    fid = figure('Position', figPosition);
    plot(t(1:SR/2,:),y(1:SR/2,:));xlabel('t'); ylabel('Y');
    title('Test Signals - [yC4 yP3 yC3 yX9 yFP1]');
    xlabel('t (sec)'); ylabel('Y');

    %---------------------------------------------- Populate EDF Structures
    
    % Populate Header
    header.edf_ver = '0';
    header.patient_id = 'test file';
    header.local_rec_id = 'EDF generator hiRes';
    header.recording_startdate = '12.04.06';
    header.recording_starttime = '07.06.00';
    header.num_header_bytes = 256+256*numSignals;
    header.reserve_1 = ' ';
    header.num_data_records = 450;
    header.data_record_duration = 1;
    header.num_signals = numSignals;
        
    % Populate Header and Signal Header
    
    for s = 1:numSignals
        % Add signal header information
        signalHeader(s).signal_labels = signalLabels{s};
        signalHeader(s).tranducer_type = 'Simulated';
        signalHeader(s).physical_dimension = 'uV';
        signalHeader(s).physical_min = -100.00;
        signalHeader(s).physical_max = 100.00;
        signalHeader(s).digital_min = -32768;
        signalHeader(s).digital_max = 32767;
        signalHeader(s).prefiltering = 'None';
        signalHeader(s).samples_in_record = SR(s);
        signalHeader(s).reserve_2 = ' ';
        
        % Add signal
        signalCell{s} = y(:,s);
    end
    
    % Echo status to console
    fprintf('\tGenerated file: %s\n', edfFnOut);
    %------------------------------------------------------ Generate Signal
    status = blockEdfWrite(edfFnOut, header, signalHeader, signalCell);
    
    %--------------------------------------- Load and Check Written Signals
    fprintf('------------------------------- Test 1\n\n');
    fprintf('\tLoad and plot generated file (%s)\n\n', edfFnOut);
    
    % Open generated test file
    [header signalHeader signalCell] = blockEdfLoad(edfFnOut);

    % Show file contents
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    tmax = 1;

    % Plot First 30 Seconds
    % Plot figures overlapping
    y = [signalCell{1}, signalCell{2}, signalCell{3}, ...
         signalCell{4}, signalCell{5}];  
    fid = figure('Position', figPosition);
    plot(t(1:SR/2,:),y(1:SR/2,:));xlabel('t'); ylabel('Y');
    title('Loaded Test Signals - [yC4 yP3 yC3 yX9 yFP1]');
    xlabel('t (sec)'); ylabel('Y');
end
% ------------------------------------------------------------------ Test 6
% Test 6: Load File and write header
if RUN_TEST_6 == 1
    % Write test results to console
    fprintf('------------------------------- Test 6\n\n');
    fprintf('Deidentify EDF, add function to write script file\n\n');
    
    % Set EDF file
    edfFn1 = 'CHAT_101020__PRE_20131202_di.edf';
    status = BlockEdfDeidentify(edfFn1);
    
end
% ------------------------------------------------------------------ Test 7
% Test 7: Load File and write header
if RUN_TEST_7 == 1
    % Write test results to console
    fprintf('------------------------------- Test 7\n\n');
    fprintf('Verify header write, with no changes\n\n');
    
    % Get header from file
    edfFnIn = 'AD122A.EDF';
    [header ] = blockEdfLoad(edfFnIn);
    
    % Write EDf
    edfFnOut = 'AD122A_write_ex2.EDF';
    status = blockEdfWrite(edfFnOut, header);
end
% ------------------------------------------------------------------ Test 8
% Test 7: Load File and write header
if RUN_TEST_8 == 1
    % Write test results to console
    fprintf('------------------------------- Test 8\n\n');
    fprintf('Test deidentify functionality\n\n');
    
    % Get header from file
    edfFnIn = 'AD122A.EDF';
    [header ] = blockEdfLoad(edfFnIn);
    
    % Deidentify
    header.recording_startdate = '06.12.04';
    header.patient_id = ' ';
    
    % Write EDf
    edfFnOut = 'AD122A_write_ex2.EDF';
    status = blockEdfWrite(edfFnOut, header);
end
end % End Testing Function
%-------------------------------------------------------- Support Functions
%-------------------------------------------------- Function PrintEdfHeader
function PrintEdfHeader(header)
    % Write header information to screen
    
    
    fprintf('Header:\n');
    fprintf('%30s:  %s\n', 'edf_ver', header.edf_ver);
    fprintf('%30s:  %s\n', 'patient_id', header.patient_id);
    fprintf('%30s:  %s\n', 'local_rec_id', header.local_rec_id);
    fprintf('%30s:  %s\n', ...
        'recording_startdate', header.recording_startdate);
    fprintf('%30s:  %s\n', ...
        'recording_starttime', header.recording_starttime);
    fprintf('%30s:  %.0f\n', 'num_header_bytes', header.num_header_bytes);
    fprintf('%30s:  %s\n', 'reserve_1', header.reserve_1);
    fprintf('%30s:  %.0f\n', 'num_data_records', header.num_data_records);
    fprintf('%30s:  %.0f\n', ...
        'data_record_duration', header.data_record_duration);
    fprintf('%30s:  %.0f\n', 'num_signals', header.num_signals);    
end
%-------------------------------------------- Function PrintEdfSignalHeader
function PrintEdfSignalHeader(header, signalHeader)
    % Write signalHeader information to screen
    fprintf('\n\nSignal Header:');

    % Plot each signal
    for s = 1:header.num_signals
        % Write summary for each signal
        fprintf('\n\n%30s:  %s\n', ...
            'signal_labels', signalHeader(s).signal_labels);
        fprintf('%30s:  %s\n', ...
            'tranducer_type', signalHeader(s).tranducer_type);
        fprintf('%30s:  %s\n', ...
            'physical_dimension', signalHeader(s).physical_dimension);
        fprintf('%30s:  %.3f\n', ...
            'physical_min', signalHeader(s).physical_min);
        fprintf('%30s:  %.3f\n', ...
            'physical_max', signalHeader(s).physical_max);
        fprintf('%30s:  %.0f\n', ...
            'digital_min', signalHeader(s).digital_min);
        fprintf('%30s:  %.0f\n', ...
            'digital_max', signalHeader(s).digital_max);
        fprintf('%30s:  %s\n', ...
            'prefiltering', signalHeader(s).prefiltering);
        fprintf('%30s:  %.0f\n', ...
            'samples_in_record', signalHeader(s).samples_in_record);
        fprintf('%30s:  %s\n', 'reserve_2', signalHeader(s).reserve_2);
    end
end
%---------------------------------------------- Function PlotEdfSignalStart
function fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax)
    % Function for plotting start of edf signals
    
    % For investigating units issues
    CLEAR_Y_AXIS = 0;
    NORMALIZE = 1;
    
    % Create figure
    figPosition = [-1919, 1, 1920, 1004];
    fig = figure('Position', figPosition);

    % Get number of signals
    num_signals = header.num_signals;

    % Add each signal to figure
    for s = 1:num_signals
        % get signal
        signal =  signalCell{s};
        record_duration = header.data_record_duration;
        samplingRate = signalHeader(s).samples_in_record/record_duration;
        
        t = [0:length(signal)-1]/samplingRate';

        % Identify first 30 seconds
        indexes = find(t<=tmax);
        signal = signal(indexes);
        t = t(indexes);
        
        
        % Normalize signal
        if NORMALIZE == 1
            sigMin = min(signal);
            sigMax = max(signal);
            signalRange = sigMax - sigMin;
            signal = (signal - sigMin);
            if signalRange~= 0
                signal = signal/(sigMax-sigMin); 
            end
            signal = signal -0.5*mean(signal) + num_signals - s + 1;         
        end
        
        % Plot signal
        plot(t(indexes), signal(indexes));
        hold on
    end

    % Set title
    title(header.patient_id);
    
    % Set axis limits
    if NORMALIZE == 1
        v = axis();
        v(1:2) = [0 tmax];
        v(3:4) = [-0.5 num_signals+1.5];
        axis(v);
    end
    
    % Set x axis
    xlabel('Time(sec)');
    
    if CLEAR_Y_AXIS == 1
        % Set yaxis labels
        signalLabels = cell(1,num_signals);
        for s = 1:num_signals
            signalLabels{num_signals-s+1} = signalHeader(s).signal_labels;
        end
        set(gca, 'YTick', [1:1:num_signals]);
        set(gca,'YTickLabel', signalLabels);
    end
    
end






































