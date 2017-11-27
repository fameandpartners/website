/* eslint-disable */

import React from "react";
import PropTypes from "prop-types";
import * as firebase from "firebase";

import StepMessage from "./StepMessage";
import TextMessage from "./TextMessage";
import JoinedMessage from "./JoinedMessage";
import DressMessage from "./DressMessage";
import FirebaseComponent from "./FirebaseComponent";

export default class ChatList extends FirebaseComponent {
  constructor(props) {
    super(props);

    this.addChatMessage = this.addChatMessage.bind(this);
    this.sameOwnerAsLastMessage = this.sameOwnerAsLastMessage.bind(this);
    this.scrollToBottom = this.scrollToBottom.bind(this);
    this.showExitModal = this.showExitModal.bind(this);
    this.sendStepMessage = this.sendStepMessage.bind(this);
    this.setMasterUserEmail = this.setMasterUserEmail.bind(this);
    this.addItem = this.addItem.bind(this);
    this.updateLocalStateStep = this.updateLocalStateStep.bind(this);
    this.addMember = this.addMember.bind(this);

    this.state = {
      messages: [],
      updateCount: 0,
      members: [],
      masterUserEmail: null,
      step: 0,
      cliqueCart: [],
    };
  }

  printMemberError(error) {
    console.log('Member List error!');
    console.log(error);
  }

  addItem(data) {
    const item = data.val().value;
    console.log(`Adding ${item.name} to Clique Cart...`);

    let updatedCart = [...this.state.cliqueCart, item];

    this.setState({
      cliqueCart: updatedCart,
    }, function() {
      this.sendStepMessage();
    });
  }

  addMember(data) {
    const member = data.val();
    console.log(`${member.from.name} joined Shopping Spree...`);

    this.setState(prevState => ({
      members: [...prevState.members, member.from],
    }));

    this.setMasterUserEmail();
  }

  updateLocalStateStep(data) {
    // bad
    this.showBanner();

    let step = data.val();
    console.log(`updateLocalStateStep(${step})...`);

    this.setState({ step });
  }

  setMasterUserEmail() {
    this.databaseRef("members")
      .orderByKey()
      .limitToLast(1)
      .once("value")
      .then((snapshot) => {
        let key = Object.keys(snapshot.val())[0];
        this.setState({
          masterUserEmail: snapshot.val()[key].from.email,
        });
        this.sendStepMessage();
      });
  }

  sendStepMessage() {
    const {
      email,
    } = this.props;
    const {
      cliqueCart,
      masterUserEmail,
      members,
      step,
    } = this.state;

    console.group('sendStepMessage()...');
    console.log(`Props Email: ${email}`);
    console.log(`Master Email: ${masterUserEmail}`);
    console.log(`Step: ${step}`);
    console.log('--- Members ---');
    console.log(members);
    console.log('--- Clique Cart ---');
    console.log(cliqueCart);
    console.groupEnd();

    if ((step == 2) && (cliqueCart.length > 0)) {
      this.createStepMessage(3);
      this.updateStepInDB(3);
    }

    const masterUser = (email == masterUserEmail);

    if (masterUser) {
      if ((step == 0) && (members.length == 1)) {
        this.createStepMessage(1);
        this.updateStepInDB(1);
      } else if ((step == 1) && (members.length == 2)) {
        this.createStepMessage(2);
        this.updateStepInDB(2);
      }
    } else {
      return;
    }
  }


  sameOwnerAsLastMessage(email) {
    if (this.state.messages.length === 0) {
      return false;
    } else {
      return (
        this.state.messages[this.state.messages.length - 1].props.email ===
          email &&
        this.state.messages[this.state.messages.length - 1].type !=
          JoinedMessage
      );
    }
  }

  addChatMessage(data) {
    let toConcat = null;
    switch (data.val().type) {
      case "step":
        toConcat = [
          <StepMessage
            key={data.key}
            step={data.val().value}
            showShareModal={this.props.showShareModal}
          />,
        ];
        break;

      case "text":
      case "discount":
        toConcat = [
          <TextMessage
            key={data.key}
            text={data.val().value}
            iconNumber={parseInt(data.val().from.icon)}
            name={data.val().from.name}
            email={data.val().from.email}
            sameOwnerAsLastMessage={this.sameOwnerAsLastMessage(
              data.val().from.email,
            )}
          />,
        ];
        break;

      case "welcome_message":
        break;

      case "share_dress":
        toConcat = [
          <DressMessage
            key={data.key}
            iconNumber={data.val().from.icon}
            name={data.val().from.name}
            email={data.val().from.email}
            sameOwnerAsLastMessage={this.sameOwnerAsLastMessage(
              data.val().from.email,
            )}
            dress={data.val().value}
            showAddToCartModal={this.props.showAddToCartModal}
          />,
        ];
        break;

      case "joined":
        toConcat = [
          <JoinedMessage
            key={data.key}
            name={data.val().from.name}
            email={data.val().from.email}
            createdAt={data.val().created_at}
          />,
        ];
        break;
      default:
        console.log("unknown card type: " + data.val().type);
    }
    if (toConcat != null) {
      this.state.messages = this.state.messages.concat(toConcat);
      this.setState({
        messages: this.state.messages,
        updateCount: this.state.updateCount + 1,
      });
    }
  }

  scrollToBottom() {
    this.bottomOfChat.scrollIntoView({ behavior: "instant", block: "end" });
  }

  printChatError(error) {
    console.log('Chat List error!');
    console.log(error);
  }

  startListeningToFirebase() {
    super.connectToFirebase();

    this.databaseRef("step")
      .on("value", this.updateLocalStateStep);

    this.databaseRef("chats")
      .on("child_added", this.addChatMessage, this.printChatError);

    this.databaseRef("members")
      .on("child_added", this.addMember, this.printMemberError);
  }

  stopListeningToFirebase() {
    this.databaseRef("chats")
      .off("child_added", this.addChatMessage);
  }

  componentDidUpdate() {
    this.scrollToBottom();
  }

  componentWillUnmount() {
    this.stopListeningToFirebase();
  }

  componentDidMount() {
    this.startListeningToFirebase();
    this.scrollToBottom();
  }

  showExitModal() {
    this.props.updateExitModalStatus();
  }

  render() {
    return (
      <div className="chat-list">
        <div className="row chat-header">
          <div className="col-xs-4 header-name">
            {this.props.name}
            {
              (this.state.members.length - 1) > 0
                ?
                (
                  <span>
                    &nbsp;and&nbsp;
                    <span className="u-text-decoration--underline">
                      {this.state.members.length - 1} more
                    </span>
                  </span>
                )
                :
                null
            }
          </div>
          <div className="col-xs-8 header-name text-right">
            <span
              className="chat-list-exit link"
              onClick={this.showExitModal}
              role="button"
            >
              Exit
            </span>
            <span
              className="link"
              onClick={this.props.showShareModal}
              role="button"
            >
              Add Friends!
            </span>
          </div>
        </div>
        <div className="row">
          <div className="chat-content">
            <div className="ChatIntroduction__wrapper">
              <h4 className="ChatIntroduction__heading">
                How it works
              </h4>
              <ol className="ChatIntroduction__steps">
                <li>
                  <span
                    className="link"
                    onClick={this.props.showShareModal}
                    role="button"
                  >
                    Invite
                  </span>
                  &nbsp;your friends to shop with you
                </li>
                <li>
                  Share dresses to your group chat form any product page
                </li>
                <li>
                  Shop and get up to 25% off when you check out together
                </li>
              </ol>
              <p className="ChatIntroduction__footer-message">
                To leave The Social Experience and shop solo, just click&nbsp;
                <span
                  className="link"
                  onClick={this.showExitModal}
                  role="button"
                >
                  exit.
                </span>
              </p>
            </div>
            <ul>{this.state.messages}</ul>
            <div
              style={{ float: "left", clear: "both" }}
              ref={el => {
                this.bottomOfChat = el;
              }}
            />
          </div>
        </div>
      </div>
    );
  }
}

ChatList.propTypes = {
  firebaseAPI: PropTypes.string.isRequired,
  firebaseDatabase: PropTypes.string.isRequired,
  firebaseNodeId: PropTypes.string.isRequired,
  showAddToCartModal: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
  doneShoppingSpree: PropTypes.func.isRequired,
  showShareModal: PropTypes.func.isRequired,
  updateExitModalStatus: PropTypes.func.isRequired,
  email: PropTypes.string.isRequired,
};
