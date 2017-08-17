import React from 'react';

export default class ChatList extends React.Component
{
    constructor( props )
    {
        super( props );
        this.initializeFirebase()
    }

    initializeFirebase()
    {
        
    }
    
    render()
    {
        return(
                <div className="chat-list">
                <div className="chat-content">Test</div>
                </div> 
        )
    }
}


