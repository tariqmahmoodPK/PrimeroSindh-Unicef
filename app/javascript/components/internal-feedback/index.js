/* eslint-disable import/exports-last */
export default function InternalFeedback() {
  return (
    <div>
      <a
        href="https://feedback.userreport.com/4f4f73f4-58c0-46df-8eb9-5c3d821df7f7/"
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
        src="https://feedback.userreport.com/4f4f73f4-58c0-46df-8eb9-5c3d821df7f7/"
        width="100%"
        height="1000px"
      />
    </div>
  );
}

InternalFeedback.displayName = "InternalFeedback";
