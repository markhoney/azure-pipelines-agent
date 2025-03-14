// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System;
using Microsoft.VisualStudio.Services.Agent.Util;
using Microsoft.VisualStudio.Services.Common;
using Microsoft.VisualStudio.Services.OAuth;
using Microsoft.VisualStudio.Services.WebApi;

namespace Microsoft.VisualStudio.Services.Agent.Listener.Configuration
{
    public class OAuthCredential : CredentialProvider
    {
        public OAuthCredential()
            : base(Constants.Configuration.OAuth)
        {
        }

        public override void EnsureCredential(
            IHostContext context,
            CommandSettings command,
            String serverUrl)
        {
            // Nothing to verify here
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA2000:Dispose objects before losing scope", MessageId = "VssOAuthJwtBearerClientCredential")]
        public override VssCredentials GetVssCredentials(IHostContext context)
        {
            var clientId = this.CredentialData.Data.GetValueOrDefault("clientId", null);
            var authorizationUrl = this.CredentialData.Data.GetValueOrDefault("authorizationUrl", null);

            // For back compat with .credential file that doesn't has 'oauthEndpointUrl' section
            var oathEndpointUrl = this.CredentialData.Data.GetValueOrDefault("oauthEndpointUrl", authorizationUrl);

            ArgUtil.NotNullOrEmpty(clientId, nameof(clientId));
            ArgUtil.NotNullOrEmpty(authorizationUrl, nameof(authorizationUrl));

            // We expect the key to be in the machine store at this point. Configuration should have set all of
            // this up correctly so we can use the key to generate access tokens.
            var keyManager = context.GetService<IRSAKeyManager>();
            var signingCredentials = VssSigningCredentials.Create(() => keyManager.GetKey());
            var clientCredential = new VssOAuthJwtBearerClientCredential(clientId, authorizationUrl, signingCredentials);
            var agentCredential = new VssOAuthCredential(new Uri(oathEndpointUrl, UriKind.Absolute), VssOAuthGrant.ClientCredentials, clientCredential);

            // Construct a credentials cache with a single OAuth credential for communication. The windows credential
            // is explicitly set to null to ensure we never do that negotiation.
            return new VssCredentials(null, agentCredential, CredentialPromptType.DoNotPrompt);
        }
    }
}
