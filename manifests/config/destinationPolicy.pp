#<destinationPolicy>
#            <policyMap>
#              <policyEntries>
#                <policyEntry topic=">" producerFlowControl="true" memoryLimit="1mb">
#                  <pendingSubscriberPolicy>
#                    <vmCursor />
#                  </pendingSubscriberPolicy>
#                </policyEntry>
#                <policyEntry queue=">" producerFlowControl="true" memoryLimit="1mb">
#                </policyEntry>
#              </policyEntries>
#            </policyMap>
#        </destinationPolicy>
define libamq::destinationPolicy {
}