import styled from 'styled-components';

const Button = styled.button`
  /* Adapt the colours based on primary prop */
  background: ${props => props.primary ? 'black' : 'white'};
  color: ${props => props.primary ? 'white' : 'black'};
  font-size: 14px;
  margin: ${props => props.noMargin ? '0' : ' 0 2em 1em'};
  padding: 0;
  border: 2px solid black;
`;

export default Button;
