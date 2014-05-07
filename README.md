#BlockEdfDeidentify

Quick de-identification of a sleep study stored in European Data Format (EDF). Options for changing study data and subject ID. Function uses [BlockEdfWrite](https://github.com/DennisDean/BlockEdfWrite/) and [BlockEdfLoad](https://github.com/DennisDean/BlockEdfLoad).



Function Prototypes:

    status = BlockEdfDeidentify(edfFn)
    status = BlockEdfDeidentify(edfFn, patient_id, recording_startdate)
