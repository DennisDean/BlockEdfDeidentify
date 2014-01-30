function testBlockEdfDeidentify()
% testBlockEdfDeidentify. Test deidentify function
%   Insure data is HIPAA compliant before sharing.
%
% Our EDF tools can be found at:
%
%                  http://sleep.partners.org/edf/
%                  http://sleepdata.org/
%
% Function prototype:
%    status = blockEdfWrite(edfFN)
%
% Test files:
%     The test files are from the  from the EDF Browser website and the 
% Sleep Heart Health Study (SHHS) (see links below). The first file is
% a generated file and the SHHS file is from an actual sleep study.
%
%
% Version: 0.1.05
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
% Last update:  January 30, 2013 
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
edfFn1 = 'test_generator_hiRes.edf';    % Test file with random header

% Test flags
RUN_TEST_1 =  1;   % Deidentify EDF

% ------------------------------------------------------------------ Test 1
% Test 1: Load File and write header
if RUN_TEST_1 == 1
    % Write test results to console
    fprintf('------------------------------- Test 1\n\n');
    fprintf('Deidentify EDF, add function to write script file\n\n');
    
    % Set EDF file
    edfFn1 = 'test_generator_hiRes.edf';
    header = blockEdfLoad(edfFn1);
    PrintEdfHeader(header)
    
    % Deidentify
    tic
        status = BlockEdfDeidentify(edfFn1);
    elapsedTime = toc;
    
    % Echo status to console
    fprintf('\n\n\nFn = %s, Time to deidentify = %.2f\n\n\n', ...
        edfFn1, elapsedTime);
    header = blockEdfLoad(edfFn1);
    PrintEdfHeader(header)
    
    % Set up for next test run
    header = blockEdfLoad(edfFn1);
    header.patient_id = 'Loren Sorensen';
    header.recording_startdate = '01.02.02';
    bytesWritten = blockEdfWrite(edfFn1, header);        
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






































