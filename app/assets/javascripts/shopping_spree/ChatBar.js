import React from 'react';

export default class ChatBar extends React.Component
{
    render()
    {
        return ( <div className="row chat-bar equal">
                 <div className="col-xs-10 no-right-gutter">
                 <input className="shoppingSpreeTextInput" type="text"></input>
                 </div>
                 <div className="col-xs-2 no-left-gutter">
                 <a className='center-block btn btn-black btn-lrg'>Send</a>
                 </div>
                 </div> );
    }
}
