/* eslint-disable import/exports-last */
export default function InternalFeedback() {
  return (
    <div>
      <a
        href="https://feedback.userreport.com/dcb9b71d-0ffc-4790-a2fc-6675bd5b8f3e/"
        target="_blank"
      >
        <h1
          style={{
            paddingLeft: "20px"
          }}
        >
          Feedback
        </h1>
      </a>
      <iframe
        title="internal-feedback"
        src="https://feedback.userreport.com/dcb9b71d-0ffc-4790-a2fc-6675bd5b8f3e/"
        width="100%"
        height="1000px"
      />
    </div>
  );
}

InternalFeedback.displayName = "InternalFeedback";
