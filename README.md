# spreedly-airlines

## Installation 
The backend of this application is written in Elixir using the Phoenix framework.

The guide I followed on installation can be found [here](https://hexdocs.pm/phoenix/overview.html).

## Use
The backend depends on a few environment variables. Once you have a Spreedly Environment setup (you can obtain an environment [here](https://www.spreedly.com/trial)) you'll need to have variables as follows:

- _TEST_GATEWAY_TOKEN_ a token for a gateway you've created
- _RECEIVER_TOKEN_ a token for a gateway you've created
- _ENVIRONMENT_KEY_ the key for your environment.
- _ENVIRONMENT_SECRET_ the API Access Secret for your environment/organization

![Screen Shot 2020-04-17 at 9 46 36 AM](/img/flight1234.png)

### Workflow
To make a purchase against a Spreedly gateway, purchase using the "Purchase (Spreedly Airlines)" button.

To make a purchase using [PMD](https://docs.spreedly.com/guides/payment-method-distribution/), checkout using the "Purchase (Expreedlia)" button. (Expreedlia being a made-up third party handler for travel purchases).

If you'd like your gateway to store your data for future use, make sure the checkbox for _Store Card for Future Payments_ is checked.

Once a button has been clicked, the Spreedly Express Payment Form will be presented allowing you to checkout using credit card data.

![Screen Shot 2020-04-17 at 9 49 51 AM](/img/spreedly_express.png)

The UI will report back on the success/failure of your transaction.

### Useful data
To test this, you should use Spreedly [test data](https://docs.spreedly.com/reference/test-data/) to have the environment behave in a predictable way.